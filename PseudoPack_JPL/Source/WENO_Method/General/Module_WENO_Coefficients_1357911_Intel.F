#include "pseudopack.h"


MODULE WENO_Coefficients

implicit NONE

PRIVATE
PUBLIC :: PS_WENO_Coefficient

CONTAINS

  Subroutine PS_WENO_Coefficient (Order, d, C, S, W)

  integer  :: Order

  REALTYPE, dimension(0:(Order-1)/2                            )           :: d
  REALTYPE, dimension(0:(Order-1)/2,0:(Order-1)/2              )           :: C
  REALTYPE, dimension(0:(Order-1)/2,0:(Order-1)/2,0:(Order-1)/2)           :: S
  REALTYPE, dimension( -(Order-1)/2:(Order-1)/2                ), OPTIONAL :: W

  integer  :: m

  m = (Order-1)/2

  SELECT CASE (Order)
    CASE (1)
      call WENO_Order_1  (m, d, C, S, W)

    CASE (3)
      call WENO_Order_3  (m, d, C, S, W)

    CASE (5)
      call WENO_Order_5  (m, d, C, S, W)

    CASE (7)
      call WENO_Order_7  (m, d, C, S, W)

    CASE (9)
      call WENO_Order_9  (m, d, C, S, W)

    CASE (11)
      call WENO_Order_11 (m, d, C, S, W)

  END SELECT

  CONTAINS

  Subroutine WENO_Order_1 (m, d, C, S, W)

  integer                                    :: m
  REALTYPE, dimension(0:m        )           :: d
  REALTYPE, dimension(0:m,0:m    )           :: C
  REALTYPE, dimension(0:m,0:m,0:m)           :: S
  REALTYPE, dimension(   -m:m    ), OPTIONAL :: W

  integer  :: i, j, k, L
  REALTYPE :: d_Factor, C_Factor, W_Factor

!----------------------------------------------------------------------
! Weight for convex combination of the lower order polynomials

  d_Factor = 1.0d0

  d(0) = 1.0d0

  d = d/d_Factor

!----------------------------------------------------------------------
! C(r,j) for the 1_th order scheme

  C_Factor = 1.0d0

  C(0,0) =  1.0d0

  C = C/C_Factor

!----------------------------------------------------------------------
! Coefficient for the Smoothness indicators
! Turn the data S into double precision for efficiency after debugging.

  S(0,0,0) =  1.0d0

!----------------------------------------------------------------------
! Optimal Weight W to form the polynomial approximation of U(i+1/2)
!  = SUM(j=-0:0) W(j) * U(i-j)

  if (.NOT. PRESENT(W)) RETURN

  W_Factor =  1.0d0

  W( 0) =  1.0d0

  W = W/W_Factor
!----------------------------------------------------------------------

  END Subroutine WENO_Order_1
!
! ====================================================================
!
  Subroutine WENO_Order_3 (m, d, C, S, W)

  integer                                    :: m
  REALTYPE, dimension(0:m        )           :: d
  REALTYPE, dimension(0:m,0:m    )           :: C
  REALTYPE, dimension(0:m,0:m,0:m)           :: S
  REALTYPE, dimension(   -m:m    ), OPTIONAL :: W

  integer  :: i, j, k, L
  REALTYPE :: d_Factor, C_Factor, W_Factor

!----------------------------------------------------------------------
! Weight for convex combination of the lower order polynomials

  d_Factor = 3.0d0

  d(0) = 1.0d0 ; d(1) =  2.0d0

  d = d/d_Factor

!----------------------------------------------------------------------
! C(r,j) for the 3_th order scheme

  C_Factor = 2.0d0

  C(0,0) = -1.0d0 ; C(0,1) =  3.0d0
  C(1,0) =  1.0d0 ; C(1,1) =  1.0d0

  C = C/C_Factor

!----------------------------------------------------------------------
! Coefficient for the Smoothness indicators
! Turn the data S into double precision for efficiency after debugging.

  S(0,0,0) =  1.0d0 ; S(0,1,0) = -2.0d0
  S(1,1,0) =  1.0d0

!----------------------------------------------------------------------

  L = (Order-1)/2
  do i = 0,L ; do j = i,L ; do k = L/2+1,L
    S(i,j,k) = S(L-j,L-i,L-k)
  enddo ; enddo ; enddo

!----------------------------------------------------------------------
! Optimal Weight W to form the polynomial approximation of U(i+1/2)
!  = SUM(j=-1:1) W(j) * U(i-j)

  if (.NOT. PRESENT(W)) RETURN

  W_Factor =  6.0d0

  W(-1) = -  1.0d0
  W( 0) =    5.0d0
  W( 1) =    2.0d0

  W = W/W_Factor
!----------------------------------------------------------------------

  END Subroutine WENO_Order_3
!
! ====================================================================
!
  Subroutine WENO_Order_5 (m, d, C, S, W)

  integer                                    :: m
  REALTYPE, dimension(0:m        )           :: d
  REALTYPE, dimension(0:m,0:m    )           :: C
  REALTYPE, dimension(0:m,0:m,0:m)           :: S
  REALTYPE, dimension(   -m:m    ), OPTIONAL :: W

  integer  :: i, j, k, L
  REALTYPE :: d_Factor, C_Factor, W_Factor

!----------------------------------------------------------------------
! Weight for convex combination of the lower order polynomials

  d_Factor = 10.0d0

  d(0) = 1.0d0 ; d(1) =  6.0d0 ; d(2) =  3.0d0 

  d = d/d_Factor

!----------------------------------------------------------------------
! C(r,j) for the 5_th order scheme

  C_Factor = 6.0d0

  C(0,0) =  2.0d0 ; C(0,1) = - 7.0d0 ; C(0,2) =  11.0d0 
  C(1,0) = -1.0d0 ; C(1,1) =   5.0d0 ; C(1,2) =   2.0d0 
  C(2,0) =  2.0d0 ; C(2,1) =   5.0d0 ; C(2,2) = - 1.0d0 

  C = C/C_Factor

!----------------------------------------------------------------------
! Coefficient for the Smoothness indicators
! Turn the data S into double precision for efficiency after debugging.

  S(0,0,0) =   16.0d0 ; S(0,1,0) = - 76.0d0 ; S(0,2,0) =  44.0d0
  S(1,1,0) =  100.0d0 ; S(1,2,0) = -124.0d0
  S(2,2,0) =   40.0d0 

!----------------------------------------------------------------------

  S(0,0,1) =   16.0d0 ; S(0,1,1) = -52.0d0 ; S(0,2,1) =  20.0d0
  S(1,1,1) =   52.0d0 ; S(1,2,1) = -52.0d0 
  S(2,2,1) =   16.0d0 

!----------------------------------------------------------------------

  L = (Order-1)/2 
  do i = 0,L ; do j = i,L ; do k = L/2+1,L
    S(i,j,k) = S(L-j,L-i,L-k)
  enddo ; enddo ; enddo

!----------------------------------------------------------------------
! Optimal Weight W to form the polynomial approximation of U(i+1/2)
!  = SUM(j=-2:2) W(j) * U(i-j)

  if (.NOT. PRESENT(W)) RETURN

  W_Factor = 60.0d0

  W(-2) =    2.0d0 ; W(-1) = -13.0d0
  W( 0) =   47.0d0
  W( 1) =   27.0d0 ; W( 2) = - 3.0d0 

  W = W/W_Factor
!----------------------------------------------------------------------

  END Subroutine WENO_Order_5
!
! ====================================================================
!
  Subroutine WENO_Order_7 (m, d, C, S, W)

  integer                                    :: m
  REALTYPE, dimension(0:m        )           :: d
  REALTYPE, dimension(0:m,0:m    )           :: C
  REALTYPE, dimension(0:m,0:m,0:m)           :: S
  REALTYPE, dimension(   -m:m    ), OPTIONAL :: W

  integer  :: i, j, k, L
  REALTYPE :: d_Factor, C_Factor, W_Factor

!----------------------------------------------------------------------
! Weight for convex combination of the lower order polynomials

  d_Factor = 35.0d0

  d(0) = 1.0d0 ; d(1) = 12.0d0 ; d(2) = 18.0d0 ; d(3) = 4.0d0

  d = d/d_Factor

!----------------------------------------------------------------------
! C(r,j) for the 7_th order scheme

  C_Factor = 12.0d0

  C(0,0) = -3.0d0 ; C(0,1) =  13.0d0 ; C(0,2) = -23.0d0 ; C(0,3) =  25.0d0
  C(1,0) =  1.0d0 ; C(1,1) = - 5.0d0 ; C(1,2) =  13.0d0 ; C(1,3) =   3.0d0
  C(2,0) = -1.0d0 ; C(2,1) =   7.0d0 ; C(2,2) =   7.0d0 ; C(2,3) = - 1.0d0
  C(3,0) =  3.0d0 ; C(3,1) =  13.0d0 ; C(3,2) = - 5.0d0 ; C(3,3) =   1.0d0

  C = C/C_Factor

!----------------------------------------------------------------------
! Coefficient for the Smoothness indicators
! Turn the data S into double precision for efficiency after debugging.

  S(0,0,0) =    547.0d0 ; S(0,1,0) = - 3882.0d0 ; S(0,2,0) =   4642.0d0
                                                  S(0,3,0) = - 1854.0d0
  S(1,1,0) =   7043.0d0 ; S(1,2,0) = -17246.0d0 ; S(1,3,0) =   7042.0d0
  S(2,2,0) =  11003.0d0 ; S(2,3,0) = - 9402.0d0
  S(3,3,0) =   2107.0d0

!----------------------------------------------------------------------

  S(0,0,1) =    267.0d0 ; S(0,1,1) = - 1642.0d0 ; S(0,2,1) =  1602.0d0
                          S(0,3,1) = -  494.0d0
  S(1,1,1) =   2843.0d0 ; S(1,2,1) = - 5966.0d0 ; S(1,3,1) =  1922.0d0
  S(2,2,1) =   3443.0d0 ; S(2,3,1) = - 2522.0d0
  S(3,3,1) =    547.0d0

!----------------------------------------------------------------------

  L = (Order-1)/2 
  do i = 0,L ; do j = i,L ; do k = L/2+1,L
    S(i,j,k) = S(L-j,L-i,L-k)
  enddo ; enddo ; enddo

!----------------------------------------------------------------------
! Optimal Weight W to form the polynomial approximation of U(i+1/2)
!  = SUM(j=-3:3) W(j) * U(i-j)

  if (.NOT. PRESENT(W)) RETURN

  W_Factor = 420.0d0

  W(-3) = -  3.0d0 ; W(-2) =  25.0d0 ; W(-1) = -101.0d0
  W( 0) =  319.0d0
  W( 1) =  214.0d0 ; W( 2) = -38.0d0 ; W( 3) =    4.0d0

  W = W/W_Factor
!----------------------------------------------------------------------

  END Subroutine WENO_Order_7
!
! ====================================================================
!
  Subroutine WENO_Order_9 (m, d, C, S, W)

  integer                                    :: m
  REALTYPE, dimension(0:m        )           :: d
  REALTYPE, dimension(0:m,0:m    )           :: C
  REALTYPE, dimension(0:m,0:m,0:m)           :: S
  REALTYPE, dimension(   -m:m    ), OPTIONAL :: W

  integer  :: i, j, k, L
  REALTYPE :: d_Factor, C_Factor, W_Factor

!----------------------------------------------------------------------
! Weight for convex combination of the lower order polynomials

  d_Factor = 126.0d0

  d(0) = 1.0d0 ; d(1) = 20.0d0 ; d(2) = 60.0d0 ; d(3) = 40.0d0 ; d(4) = 5.0d0

  d = d/d_Factor

!----------------------------------------------------------------------
! C(r,j) for the 9th order scheme

  C_Factor = 60.0d0

  C(0,0) =   12.0d0 ; C(0,1) = - 63.0d0 ; C(0,2) =  137.0d0
                      C(0,3) = -163.0d0 ; C(0,4) =  137.0d0
  C(1,0) = -  3.0d0 ; C(1,1) =   17.0d0 ; C(1,2) = - 43.0d0
                      C(1,3) =   77.0d0 ; C(1,4) =   12.0d0
  C(2,0) =    2.0d0 ; C(2,1) = - 13.0d0 ; C(2,2) =   47.0d0
                      C(2,3) =   27.0d0 ; C(2,4) = -  3.0d0
  C(3,0) = -  3.0d0 ; C(3,1) =   27.0d0 ; C(3,2) =   47.0d0
                      C(3,3) = - 13.0d0 ; C(3,4) =    2.0d0
  C(4,0) =   12.0d0 ; C(4,1) =   77.0d0 ; C(4,2) = - 43.0d0
                      C(4,3) =   17.0d0 ; C(4,4) = -  3.0d0

  C = C/C_Factor

!----------------------------------------------------------------------
! Coefficient for the Smoothness indicators
! Turn the data S into double precision for efficiency after debugging.

  S(0,0,0) =    22658.0d0 ; S(0,1,0) = - 208501.0d0 ; S(0,2,0) =   364863.0d0
                            S(0,3,0) = - 288007.0d0 ; S(0,4,0) =    86329.0d0
  S(1,1,0) =   482963.0d0 ; S(1,2,0) = -1704396.0d0 ; S(1,3,0) =  1358458.0d0
                            S(1,4,0) = - 411487.0d0
  S(2,2,0) =  1521393.0d0 ; S(2,3,0) = -2462076.0d0 ; S(2,4,0) =   758823.0d0
  S(3,3,0) =  1020563.0d0 ; S(3,4,0) = - 649501.0d0
  S(4,4,0) =   107918.0d0
!----------------------------------------------------------------------

  S(0,0,1) =     6908.0d0 ; S(0,1,1) = -  60871.0d0 ; S(0,2,1) =    99213.0d0
                            S(0,3,1) = -  70237.0d0 ; S(0,4,1) =    18079.0d0
  S(1,1,1) =   138563.0d0 ; S(1,2,1) = - 464976.0d0 ; S(1,3,1) =   337018.0d0
                            S(1,4,1) = -  88297.0d0
  S(2,2,1) =   406293.0d0 ; S(2,3,1) = - 611976.0d0 ; S(2,4,1) =   165153.0d0
  S(3,3,1) =   242723.0d0 ; S(3,4,1) = - 140251.0d0
  S(4,4,1) =    22658.0d0
!----------------------------------------------------------------------

  S(0,0,2) =     6908.0d0 ; S(0,1,2) = -  51001.0d0 ; S(0,2,2) =    67923.0d0
                            S(0,3,2) = -  38947.0d0 ; S(0,4,2) =     8209.0d0
  S(1,1,2) =   104963.0d0 ; S(1,2,2) = - 299076.0d0 ; S(1,3,2) =   179098.0d0
                            S(1,4,2) = -  38947.0d0
  S(2,2,2) =   231153.0d0 ; S(2,3,2) = - 299076.0d0 ; S(2,4,2) =    67923.0d0
  S(3,3,2) =   104963.0d0 ; S(3,4,2) = -  51001.0d0
  S(4,4,2) =     6908.0d0

!----------------------------------------------------------------------

  L = (Order-1)/2 
  do i = 0,L ; do j = i,L ; do k = L/2+1,L
    S(i,j,k) = S(L-j,L-i,L-k)
  enddo ; enddo ; enddo

!----------------------------------------------------------------------
! Optimal Weight W to form the polynomial approximation of U(i+1/2)
!  = SUM(j=-4:4) W(j) * U(i+j)

  if (.NOT. PRESENT(W)) RETURN

  W_Factor = 2520.0d0

  W(-4) =     4.0d0 ; W(-3) = -   41.0d0 ; W(-2) =  199.0d0
                      W(-1) = -  641.0d0 ;
  W(0 ) =  1879.0d0
  W(1 ) =  1375.0d0 ; W( 2) = -  305.0d0 ; W( 3) =   55.0d0
                      W( 4) = -    5.0d0

  W = W/W_Factor
!----------------------------------------------------------------------

  END Subroutine WENO_Order_9
!
! ====================================================================
!
  Subroutine WENO_Order_11 (m, d, C, S, W)

  integer                                    :: m
  REALTYPE, dimension(0:m        )           :: d
  REALTYPE, dimension(0:m,0:m    )           :: C
  REALTYPE, dimension(0:m,0:m,0:m)           :: S
  REALTYPE, dimension(   -m:m    ), OPTIONAL :: W

  integer  :: i, j, k, L
  REALTYPE :: d_Factor, C_Factor, W_Factor

!----------------------------------------------------------------------
! Weight for convex combination of the lower order polynomials

  d_Factor = 462.0d0

  d(0) = 1.0d0 ; d(1) = 30.0d0 ; d(2) = 150.0d0 ; d(3) = 200.0d0
                 d(4) = 75.0d0 ; d(5) =   6.0d0

  d = d/d_Factor

!----------------------------------------------------------------------
! C(r,j) for the 11_th order scheme

  C_Factor = 60.0d0

  C(0,0) = - 10.0d0 ; C(0,1) =   62.0d0 ; C(0,2) = -163.0d0
                      C(0,3) =  237.0d0 ; C(0,4) = -213.0d0 ; C(0,5) =  147.0d0

  C(1,0) =    2.0d0 ; C(1,1) = - 13.0d0 ; C(1,2) =   37.0d0
                      C(1,3) = - 63.0d0 ; C(1,4) =   87.0d0 ; C(1,5) =   10.0d0

  C(2,0) = -  1.0d0 ; C(2,1) =    7.0d0 ; C(2,2) = - 23.0d0
                      C(2,3) =   57.0d0 ; C(2,4) =   22.0d0 ; C(2,5) = -  2.0d0

  C(3,0) =    1.0d0 ; C(3,1) = -  8.0d0 ; C(3,2) =   37.0d0
                      C(3,3) =   37.0d0 ; C(3,4) = -  8.0d0 ; C(3,5) =    1.0d0

  C(4,0) = -  2.0d0 ; C(4,1) =   22.0d0 ; C(4,2) =   57.0d0
                      C(4,3) = - 23.0d0 ; C(4,4) =    7.0d0 ; C(4,5) = -  1.0d0

  C(5,0) =   10.0d0 ; C(5,1) =   87.0d0 ; C(5,2) = - 63.0d0
                      C(5,3) =   37.0d0 ; C(5,4) = - 13.0d0 ; C(5,5) =    2.0d0

  C = C/C_Factor

!----------------------------------------------------------------------
! Coefficient for the Smoothness indicators
! Turn the data S into double precision for efficiency after debugging.

  S(0,0,0) =    1152561.0d0; S(0,1,0) = - 12950184.0d0; S(0,2,0) =  29442256.0d0
                             S(0,3,0) = - 33918804.0d0; S(0,4,0) =  19834350.0d0
                             S(0,5,0) = -  4712740.0d0
  S(1,1,0) =   36480687.0d0; S(1,2,0) = -166461044.0d0; S(1,3,0) = 192596472.0d0
                             S(1,4,0) = -113206788.0d0; S(1,5,0) =  27060170.0d0
  S(2,2,0) =  190757572.0d0; S(2,3,0) = -444003904.0d0; S(2,4,0) = 262901672.0d0
                             S(2,5,0) = - 63394124.0d0
  S(3,3,0) =  260445372.0d0; S(3,4,0) = -311771244.0d0; S(3,5,0) =  76206736.0d0
  S(4,4,0) =   94851237.0d0; S(4,5,0) = - 47460464.0d0
  S(5,5,0) =    6150211.0d0

!----------------------------------------------------------------------

  S(0,0,1) =     271779.0d0; S(0,1,1) = - 3015728.0d0; S(0,2,1) =    6694608.0d0
                             S(0,3,1) = - 7408908.0d0; S(0,4,1) =    4067018.0d0
                             S(0,5,1) = -  880548.0d0
  S(1,1,1) =    8449957.0d0; S(1,2,1) = -37913324.0d0; S(1,3,1) =   42405032.0d0
                             S(1,4,1) = -23510468.0d0; S(1,5,1) =    5134574.0d0
  S(2,2,1) =   43093692.0d0; S(2,3,1) = -97838784.0d0; S(2,4,1) =   55053752.0d0
                             S(2,5,1) = -12183636.0d0
  S(3,3,1) =   56662212.0d0; S(3,4,1) = -65224244.0d0; S(3,5,1) =   14742480.0d0
  S(4,4,1) =   19365967.0d0; S(4,5,1) = - 9117992.0d0
  S(5,5,1) =    1152561.0d0

!----------------------------------------------------------------------

  S(0,0,2) =     139633.0d0; S(0,1,2) = -  1429976.0d0; S(0,2,2) =   2863984.0d0
                             S(0,3,2) = -  2792660.0d0; S(0,4,2) =   1325006.0d0
                             S(0,5,2) = -   245620.0d0
  S(1,1,2) =    3824847.0d0; S(1,2,2) = - 15880404.0d0; S(1,3,2) =  15929912.0d0
                             S(1,4,2) = -  7727988.0d0; S(1,5,2) =   1458762.0d0
  S(2,2,2) =   17195652.0d0; S(2,3,2) = - 35817664.0d0; S(2,4,2) =  17905032.0d0
                             S(2,5,2) = -  3462252.0d0
  S(3,3,2) =   19510972.0d0; S(3,4,2) = - 20427884.0d0; S(3,5,2) =   4086352.0d0
  S(4,4,2) =    5653317.0d0; S(4,5,2) = -  2380800.0d0
  S(5,5,2) =     271779.0d0

!----------------------------------------------------------------------
  L = (Order-1)/2 
  do i = 0,L ; do j = i,L ; do k = L/2+1,L
    S(i,j,k) = S(L-j,L-i,L-k)
  enddo ; enddo ; enddo

!----------------------------------------------------------------------
! Optimal Weight W to form the polynomial approximation of U(i+1/2) at the
! cell interface from the cell centered values U(i-5:i+5)
! = SUM(j=-5:5) W(j) * U(i-j) 
!
! Note :  W(j) can be computed by multiply C(i,:) with d(i)  = e(i,:)
!         Shift each elements of row e(i,:) right by i = e(i,k+i), k=0..L
!         Sum up the each columns to form W(j)
!         W_Factor = d_Factor*C_Factor

  if (.NOT. PRESENT(W)) RETURN

  W_Factor = 27720.0d0

  W(-5) =   -10.0d0 ; W(-4) =   122.0d0 ; W(-3) = -703.0d0 ; W(-2) = 2597.0d0
                      W(-1) = -7303.0d0 ;
  W(0 ) = 20417.0d0
  W(1 ) = 15797.0d0 ; W( 2) = -4003.0d0 ; W( 3) =  947.0d0
                      W( 4) = - 153.0d0 ; W( 5) =   12.0d0

  W = W/W_Factor
!----------------------------------------------------------------------

  END Subroutine WENO_Order_11

  END Subroutine PS_WENO_Coefficient 

END MODULE WENO_Coefficients
