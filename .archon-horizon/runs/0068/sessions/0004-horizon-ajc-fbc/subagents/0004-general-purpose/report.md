Yes — kernel result obtained. `janitor` remains unreachable via SendMessage (three attempts), so relaying here for the caller to pass on:

Yes: `pullback_preservesKernel_of_isQuasicoherent` → `[propext, Classical.choice, Quot.sound]` (lean_verify, and reconfirmed by `#print axioms`); `mapHomologicalComplexHomologyIso_of_preservesKernel` → `[propext, Classical.choice, Quot.sound]` (same two methods); `leakControl_qcohRoute_oldRoute` → `[propext, sorryAx, Classical.choice, Quot.sound]` (`#print axioms` on a verbatim copy in a scratch file, not on the 92KB script itself).
