 < ? p h p   
 
 	 $ x s l D o c   =   n e w   D O M D o c u m e n t ( ) ; 
 	 $ x s l D o c - > l o a d ( " t e s t . x s l " ) ; 
 	 / / p r i n t ( " L o a d e d   X S L T \ n " ) ; 
 
 	 / / $ x m l D o c   =   n e w   D O M D o c u m e n t ( ) ; 
 	 / / $ x m l D o c - > l o a d ( " t e s t . x m l " ) ; 
 	 / / p r i n t ( " L o a d e d   X M L \ n " ) ; 
 	 
       	 i f ( f i l e _ e x i s t s ( ' t e s t . t x t ' ) ) 
       	 	 u n l i n k ( ' t e s t . t x t ' ) ; 	 
       	 	 
 	 $ o u t c o m e   =   f o p e n ( ' t e s t . t x t ' ,   ' a ' ) ; 	 
 	 $ l o g   =   f o p e n ( ' l o g . t x t ' ,   ' w ' ) ; 	 
 
 	 $ p a t t e r n s   =   a r r a y ( ) ;       
       	 	 	 	 
 	 / / $ p a t h s   =   g l o b ( ' D D B _ E p i D o c _ X M L / c . e p . l a t / * . x m l ' ) ; 
 	 
 	 $ t o p   =   r e a l p a t h ( ' D D B _ E p i D o c _ X M L ' ) ; 
 	 
 	 $ f i l e B a s e U R I   =   " h t t p : / / p a p y r i . i n f o / d d b d p / " ; 
 	 
 	 / / p r i n t ( $ t o p ) ; 
 
 	 f o r e a c h   ( n e w   R e g e x I t e r a t o r ( n e w   R e c u r s i v e I t e r a t o r I t e r a t o r ( n e w   R e c u r s i v e D i r e c t o r y I t e r a t o r ( $ t o p ) ,                                                                                     R e c u r s i v e I t e r a t o r I t e r a t o r : : C H I L D _ F I R S T ) ,   ' / ^ . + \ . x m l $ / i ' ,   R e c u r s i v e R e g e x I t e r a t o r : : G E T _ M A T C H   )   a s   $ f i l e )   
 	 { 
 	 	 / / f w r i t e ( $ o u t c o m e ,   " ( f i l e )   "   .   $ f i l e [ 0 ]   .   " \ n " ) ; 
       	 	 	 
 	 / / 	 f o r e a c h ( $ p a t h s   a s   $ p a t h ) 
 	 / / 	 { 
 	 	 	 / / f w r i t e ( $ o u t c o m e ,   " F i l e :   "   .   $ p a t h   .   " \ n " ) ; 
 	 	 	 
 	 	 	 $ p a t h   =   $ f i l e [ 0 ] ; 
 	 
 	 	 	 $ x m l D o c   =   n e w   D O M D o c u m e n t ( ) ; 
 	 	 	 $ x m l D o c - > l o a d ( $ p a t h ) ; 
 	 	 	 f w r i t e ( $ l o g ,   " L o a d e d   "   .   $ p a t h   .   " \ n " ) ; 	 
 	 
 	 	 	 $ p r o c   =   n e w   X S L T P r o c e s s o r ( ) ; 
 	 	 	 $ p r o c - > i m p o r t S t y l e s h e e t ( $ x s l D o c ) ; 
 	 
 	 	 	 
 	 	 	 $ r e s u l t   =   $ p r o c - > t r a n s f o r m T o X M L ( $ x m l D o c ) ; 
 	       
 	 	 	 / / f w r i t e ( $ o u t c o m e ,   $ r e s u l t ) ; 
 	 	 	 
 	 	 	 $ c u r r e n t   =   e x p l o d e ( " * * * * " ,   $ r e s u l t ) ; 
 	 	 	 
 	 	 	 f o r e a c h ( $ c u r r e n t   a s   $ f o u n d ) 
 	 	 	 { 
 	 	 	 	 $ p a r t s   =   e x p l o d e ( " | " ,   $ f o u n d ) ; 
 	 	 	 	 
 	 	 	 	 i f ( ' '   ! =   t r i m ( $ f o u n d ) ) 
 	 	 	 	 { 
 	 	 	 	 	 i f ( 5   = =   c o u n t ( $ p a r t s ) ) 
 	 	 	 	 	 { 
 	 	 	 	 	 	 $ t y p e   =   t r i m ( $ p a r t s [ 0 ] ) ; 
 	 	 	 	 	 	 $ r e f   =   t r i m ( $ p a r t s [ 1 ] ) ; 
 	 	 	 	 	 	 $ l i n e   =   t r i m ( $ p a r t s [ 2 ] ) ; 
 	 	 	 	 	 	 $ c h u n k   =   $ p a r t s [ 3 ] ; 
 	 	 	 	 	 	 $ x m l   =   $ p a r t s [ 4 ] ; 
 	 	 	 	 	 	 
 	 	 	 	 	 	 
 	 	 	 	 	 	 $ s P a t t e r n   =   ' / \ s * / m ' ; 
 	 	 	 	 	 	 $ s P a t t e r n 2   =   ' / \ s + / m ' ; 
 	 	 	 	 	 	 $ s R e p l a c e   =   ' ' ; 
 	 	 	 	 	 	 $ s R e p l a c e 2   =   '   ' ; 
 	 	 	 	 	 	 $ c h u n k   =   p r e g _ r e p l a c e (   $ s P a t t e r n ,   $ s R e p l a c e ,   $ c h u n k   ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " - - " ,   " - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ - " ,   " [ " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " - ] " ,   " ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - e d i t o r i a l " ,   " A P P e d " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - a l t e r n a t i v e " ,   " A P P a l t " ,   $ c h u n k ) ; 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - B L " ,   " A P P b l " ,   $ c h u n k ) ; 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - S o S O L " ,   " A P P s o l " ,   $ c h u n k ) ; 	 
 	 	 	 	 	 	 	 	 	 
 	 	 	 	 	 	 $ x m l   =   s t r _ r e p l a c e ( '   x m l n s = " h t t p : / / w w w . t e i - c . o r g / n s / 1 . 0 " ' ,   ' ' ,   $ x m l ) ; 
 	 	 	 	 	 	 
 	 	 	 	 	 	 $ x m l   =   p r e g _ r e p l a c e ( " / < \ s * \ / ? \ s * s u p p l i e d \ s * . * ? > / m " ,   " " ,   $ x m l   ) ;   
 	 	 	 	 	 	 $ x m l   =   p r e g _ r e p l a c e ( " / < \ s * \ / ? \ s * u n c l e a r \ s * . * ? > / m " ,   " " ,   $ x m l   ) ;   
 	 	 	 	 	 	 $ x m l   =   p r e g _ r e p l a c e ( " / < \ s * \ / ? \ s * e x \ s * . * ? > / m " ,   " " ,   $ x m l   ) ;   
 	 	 	 	 	 	 $ x m l   =   p r e g _ r e p l a c e ( " / < \ s * \ / ? \ s * e x p a n \ s * . * ? > / m " ,   " " ,   $ x m l   ) ;   
 	 	 	 	 	 	 
 	 	 	 	 	 	 $ x m l   =   p r e g _ r e p l a c e (   $ s P a t t e r n 2 ,   $ s R e p l a c e 2 ,   $ x m l   ) ; 
 	 	 	 	 	 	 
 	 	 	 	 	 	 $ l i n e   =   " R e f :   "   .   p r e g _ r e p l a c e (   $ s P a t t e r n ,   $ s R e p l a c e ,   $ l i n e   ) ; 
 	 	 	 	 	 	 
 	 	 	 	 	 	 / / p r i n t ( " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \ n " ) ; 
 	 	 	 	 	 	 / / p r i n t ( " 1 .   T y p e :   "   .   $ t y p e   .   "   P a t t e r n s :   " ) ; 
 	 	 	 	 	 	 / / p r i n t _ r ( $ p a t t e r n s ) ; 
 	 	 	 	 	 	 
 	 	 	 	 	 	 i f ( a r r a y _ k e y _ e x i s t s ( $ t y p e ,   $ p a t t e r n s ) ) 
 	 	 	 	 	 	 { 
 	 	 	 	 	 	 	 $ t y p e _ a r r a y   =   $ p a t t e r n s [ $ t y p e ] ; 
 	 	 	 	 	 	 	 
 	 	 	 	 	 	 	 / / p r i n t ( " \ t 2 .   C h u n k :   "   .   $ c h u n k   .   "   T y p e _ a r r a y :   " ) ; 
 	 	 	 	 	 	 	 / / p r i n t _ r ( $ t y p e _ a r r a y ) ; 
 	 	 	 	 	 	 	 
 	 	 	 	 	 	 	 i f ( ! a r r a y _ k e y _ e x i s t s ( $ c h u n k ,   $ t y p e _ a r r a y ) ) 
 	 	 	 	 	 	 	 { 
 	 	 	 	 	 	 	 	 / / p r i n t ( " \ t \ t   N o   m a t c h   -   a d d   d e t a i l s \ n " ) ; 
 	 	 	 	 	 	 	 	 $ t y p e _ a r r a y [ $ c h u n k ] [ " f i l e " ]   =   $ f i l e B a s e U R I   .   $ r e f ; 
 	 	 	 	 	 	 	 	 $ t y p e _ a r r a y [ $ c h u n k ] [ " r e f " ]   =   $ l i n e ; 
 	 	 	 	 	 	 	 	 $ t y p e _ a r r a y [ $ c h u n k ] [ " x m l " ]   =   a r r a y ( $ x m l ) ; 
 	 	 	 	 	 	 	 	 $ t y p e _ a r r a y [ $ c h u n k ] [ " c o u n t " ]   =   " 1 " ; 
 	 	 	 	 	 	 	 	 
 	 	 	 	 	 	 	 	 $ p a t t e r n s [ $ t y p e ]   =   $ t y p e _ a r r a y ; 
 	 	 	 	 	 	 	 } 
 	 	 	 	 	 	 	 e l s e 
 	 	 	 	 	 	 	 { 
 	 	 	 	 	 	 	 	 i f ( $ t y p e _ a r r a y [ $ c h u n k ] [ " c o u n t " ]   <   5 ) 
 	 	 	 	 	 	 	 	 	 $ p a t t e r n s [ $ t y p e ] [ $ c h u n k ] [ " x m l " ] [ $ t y p e _ a r r a y [ $ c h u n k ] [ " c o u n t " ] ]   =   $ x m l ; 
 	 	 	 	 	 	 	 	 
 	 	 	 	 	 	 	 	 / / p r i n t ( " \ t \ t   M a t c h   -   i n c r e a s e   c o u n t   \ n " ) ; 
 	 	 	 	 	 	 	 	 $ p a t t e r n s [ $ t y p e ] [ $ c h u n k ] [ " c o u n t " ]   =   $ t y p e _ a r r a y [ $ c h u n k ] [ " c o u n t " ]   +   1 ; 
 	 	 	 	 	 	 	 	 / / p r i n t _ r ( $ p a t t e r n s [ $ t y p e ] ) ; 
 	 	 	 	 	 	 	 	 
 
 	 	 	 	 	 	 	 } 
 	 	 	 	 	 	 } 
 	 	 	 	 	 	 e l s e 
 	 	 	 	 	 	 	 $ p a t t e r n s [ $ t y p e ]   =   a r r a y ( $ c h u n k   = >   a r r a y ( " f i l e " = > $ f i l e B a s e U R I   .   $ r e f ,   " r e f " = > $ l i n e ,   " x m l " = > a r r a y ( $ x m l ) ,   " c o u n t " = > " 1 " ) ) ; 
 	 	 	 	 	 	 	 
 	 	 
 	 	 	 	 	 } 
 	 	 	 	 	 e l s e i f   ( 1   = =   c o u n t ( $ p a r t s ) ) 
 	 	 	 	 	 { 
 	 	 	 	 	 	 / / f w r i t e ( $ o u t c o m e ,   t r i m ( $ p a r t s [ 0 ] )   .   " \ n \ n " ) ; 
 	 	 	 	 	 } 
 	 	 	 	 	 e l s e 
 	 	 	 	 	 	 p r i n t ( " E r r o r   -   w r o n g   n u m b e r   o f   p a r t s   i n   "   .   $ p a t h   .   "   ( "   .   c o u n t ( $ p a r t s )   .   " ) :   ' "   .   $ f o u n d   .   " ' \ n " ) ; 
 	 	 	 	 } 
 	 	 	 } 
 	 	 	 
 	 	 	 / / f w r i t e ( $ o u t c o m e ,   " \ n \ n " ) ; 
 	 	 	 
 	 	 	 / / p r i n t _ r ( $ p a t t e r n s ) ; 
 	 	 
 	 	 / / } 
 	 
 	 } 
 	 
 
 	 
 	 / /   T O   D O   -   i f   p o s s i b l e ,   s o r t   b y   c o u n t 
 	 
 	 $ o u t p u t   =   a r r a y ( ) ; 
 	 
 	 f o r e a c h ( $ p a t t e r n s   a s   $ k e y   = >   $ t y p e ) 
 	 { 
 	 	 
 	 	 / /   f w r i t e ( $ o u t c o m e ,   $ k e y   .   " \ n " ) ; 
 	 	 
 	 	 
 	 	 f o r e a c h ( $ t y p e   a s   $ p a t t e r n   = >   $ r e f ) 
 	 	 { 	 	 	 
 	 	 	 / / f w r i t e ( $ o u t c o m e ,   $ r e f [ " c o u n t " ]   .   " \ t "   .   $ p a t t e r n   .     " \ t "   .   $ r e f [ " x m l " ]   .   " \ t "   .   " \ t "   .   " \ t "   .   " \ t "   .   $ r e f [ " f i l e " ]   .   " \ t "   .   $ r e f [ " r e f " ]   .   " \ n " ) ; 
 	 	 	 
 	 	 	 f o r e a c h ( $ r e f [ " x m l " ]   a s   $ e g ) 
 	 	 	 { 
 	 	 	 
 	 	 	 	 $ o u t p u t [ $ r e f [ " c o u n t " ]   .   " \ t "   .   $ p a t t e r n   .     " \ t "   .   $ e g   .   " \ t "   .   " \ t "   .   " \ t "   .   " \ t "   .   $ r e f [ " f i l e " ]   .   " \ t "   .   $ r e f [ " r e f " ]   .   " \ n " ]   =   $ r e f [ " c o u n t " ]   .   "   "   .   $ p a t t e r n ; 
 	 	 	 } 
 	 	 } 
 	 	 
 	 	 / / f w r i t e ( $ o u t c o m e ,   " \ n \ n " ) ; 
 	 	 
 	 } 
 	 
 	 u a s o r t ( $ o u t p u t ,   " c m p " ) ; 
 	 
 	 f o r e a c h ( $ o u t p u t   a s   $ v a l u e   = >   $ c o u n t ) 
 	 { 
 	 	 f w r i t e ( $ o u t c o m e ,   $ v a l u e ) ; 
 	 } 
 	 
 	 / / p r i n t _ r ( $ p a t t e r n s ) ; 
 	 f c l o s e ( $ o u t c o m e ) ; 	 
 	 f c l o s e ( $ l o g ) ; 
 
 
 / * 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ C H ] [ / C H ] " ,   " [ - C H - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ C O R R ] [ / C O R R ] " ,   " [ - C O R R - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ S I C ] [ / S I C ] " ,   " [ - S I C - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ R E G ] [ / R E G ] " ,   " [ - R E G - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ S U B ] [ / S U B ] " ,   " [ - S U B - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ O R I G ] [ / O R I G ] " ,   " [ - O R I G - ] " ,   $ c h u n k ) ; 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ R D G ] [ / R D G ] " ,   " [ - R D G - ] " ,   $ c h u n k ) ; 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ L E M ] [ / L E M ] " ,   " [ - L E M - ] " ,   $ c h u n k ) ; 	 	 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ A P P - a l t e r n a t i v e ] [ / A P P - a l t e r n a t i v e ] " ,   " [ - A P P - a l t - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ A P P - e d i t o r i a l ] [ / A P P - e d i t o r i a l ] " ,   " [ - A P P - e d - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ A P P - e d i t o r i a l ] " ,   " [ A P P - e d ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ / A P P - e d i t o r i a l ] " ,   " [ / A P P - e d ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ A P P - a l t e r n a t i v e ] " ,   " [ A P P - a l t ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ / A P P - a l t e r n a t i v e ] " ,   " [ / A P P - a l t ] " ,   $ c h u n k ) ; 	 	 	 	 	 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ A P P - B L ] [ / A P P - B L ] " ,   " [ - A P P - B L - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ A P P - S o S O L ] [ / A P P - S o S O L ] " ,   " [ - A P P - S o S O L - ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " C H ] [ - " ,   " C H - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " C H ] [ " ,   " C H - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ / C H ] " ,   " ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " S U B ] [ - " ,   " S U B - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " S U B ] [ " ,   " S U B - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ / S U B ] " ,   " ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - e d ] [ - " ,   " A P P - e d - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - e d ] [ " ,   " A P P - e d - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ / A P P - e d ] " ,   " ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - a l t ] [ - " ,   " A P P - a l t - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " A P P - a l t ] [ " ,   " A P P - a l t - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ / A P P - a l t ] " ,   " ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 
 	 	 	 	 	 	 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " - ] [ - " ,   " - " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " [ - " ,   " [ " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " - ] " ,   " ] " ,   $ c h u n k ) ; 
 	 	 	 	 	 	 $ c h u n k   =   s t r _ r e p l a c e ( " ] ] " ,   " ] " ,   $ c h u n k ) ; 
 * / 
 
 f u n c t i o n   c m p ( $ a ,   $ b ) 
 { 
 	 / / p r i n t ( " c m p   c a l l e d \ n " ) ; 
 	 
 	 $ p a r t s A   =   e x p l o d e ( "   " ,   $ a ) ; 
 	 $ p a r t s B   =   e x p l o d e ( "   " ,   $ b ) ; 
 	 
 	 / / p r i n t ( " A :   "   .   $ a   .   "   "   .   $ p a r t s A [ 0 ]   .   "   "   .   $ p a r t s A [ 1 ]   .   " \ n " ) ; 
 	 / / p r i n t ( " B :   "   .   $ b   .   "   "   .   $ p a r t s B [ 0 ]   .   "   "   .   $ p a r t s B [ 1 ]   .   " \ n " ) ; 
 	 
         i f   ( $ p a r t s A [ 0 ]   = =   $ p a r t s B [ 0 ] )   
         { 
                 r e t u r n   s t r c m p ( $ p a r t s A [ 1 ] ,   $ p a r t s B [ 1 ] ) ; 
         } 
         r e t u r n   ( $ p a r t s A [ 0 ]   >   $ p a r t s B [ 0 ] )   ?   - 1   :   1 ; 
 } 	 
 ? > 
