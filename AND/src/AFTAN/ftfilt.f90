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
!-------------------------------------------------
! FTAN filter: y = x*exp(-alpha*((om-om0)/om0)**2
!-------------------------------------------------
subroutine ftfilt(alpha, om0, dom, n, a, fs)

implicit none

integer(4), intent(in) :: n

real(4), intent(in) :: alpha, om0, dom

complex, intent(in) :: a(n)


complex, intent(out) :: fs(n)



integer(4) k

complex czero


real(4) ome, om2, b



czero = cmplx(0.0, 0.0)

do k = 1, n, 1

   fs(k) = czero
   b = 0.0
   ome = (k-1)*dom
   om2 = -alpha*(ome - om0)/om0*(ome - om0)/om0

   if (abs(om2) <= 40.0) then
      b = exp(om2)
      fs(k) = a(k)*b
   endif

enddo


return


end subroutine ftfilt
