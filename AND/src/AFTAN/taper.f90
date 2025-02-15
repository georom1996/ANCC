! This file is part of ANCC.
!
! AFTAN is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! AFTAN is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <https://www.gnu.org/licenses/>.
!
!
!
!----------------------------------------------------------
! tapering both end of input seismogram
!----------------------------------------------------------
module taper_m


implicit none


contains


subroutine taper(nb, ne, n, seis, ntapb, ntape, ncorr, ss)

implicit none

integer(4), intent(in) :: nb, ne, n
integer(4), intent(in) :: ntapb, ntape

real(4), intent(in) :: seis(n)


integer(4), intent(out) :: ncorr

complex, dimension(:), allocatable, intent(out) :: ss


integer(4) k, ns, ier

real(8), parameter :: PI = 4.d0*datan(1.d0)

real(4) omb, ome, sums, c, r

real(4), dimension(:), allocatable :: s



omb = PI/ntapb
ome = PI/ntape
ncorr = ne + ntape


! make copy seis to s
allocate(s(n), stat=ier)
s(1:ncorr) = seis(1:ncorr)
if ((nb-ntapb-1) > 0) then
   s(1:nb-ntapb-1) = 0.0
endif

sums = 0.0
! left end of the signal
do k = nb, nb-ntapb, -1
   r = 0.50*(1.0 + cos(omb*(nb - k)))
   sums = sums + 2.0*r
   s(k) = s(k)*r
enddo
! right end of the signal
do k = ne, ne+ntape, 1
   s(k) = 0.50*(1.0 + cos(ome*(ne - k)))*s(k)
enddo
sums = sums + ne - nb - 1
c = 0.d0
do k = 1, ncorr, 1
   c = c + s(k)
enddo
c = -c/sums

! left end of the signal
do k = nb, nb-ntapb, -1
   r = 0.50*(1.0 + cos(omb*(nb - k)))
   s(k) = s(k) + r*c
enddo

! right end of the signal
do k = ne, ne+ntape, 1
   r = 0.50*(1.0 + cos(ome*(ne - k)))
   s(k) = s(k) + r*c
enddo

! middle of the signal
s(nb+1:ne-1) = s(nb+1:ne-1) + c


! determine the power of FFT
!ns = 2**(min(max(int(dlog(dble(ncorr))/dlog(2.d0)) + 1, 12), 16))
ns = 2**ceiling(dlog(dble(ncorr))/dlog(2.d0))
if (ns > ncorr) then
   s(ncorr+1:ns) = 0.0
endif
ncorr = ns


! convert to complex
allocate(ss(1:ns), stat=ier)
do k = 1, ns, 1
   ss(k) = cmplx(s(k), 0.0)
enddo


deallocate(s)


return


end subroutine taper


end module taper_m
