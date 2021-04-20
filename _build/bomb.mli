type t

val make_bomb : Player.t -> t

val explode : State.t -> t -> State.t
