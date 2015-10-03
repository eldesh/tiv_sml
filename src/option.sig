signature OPTION =
   sig
      datatype t = datatype option
         
      val map: 'a t * ('a -> 'b) -> 'b t
   end
