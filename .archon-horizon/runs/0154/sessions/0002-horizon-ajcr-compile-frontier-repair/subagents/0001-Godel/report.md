The `hOpen` helper is required for the RingHom/CommRing mismatch, but it is not the 10-minute elaboration driver: its exact dependent probe compiled in about 27 seconds. `hmapM` is a direct producer equality and is unlikely to gain from splitting.

The smallest useful elaboration split is to bind an explicitly typed `hthetaN'` before the structure literal, with the existing `simpa only [Q, pic0FiniteStageTransportedTripleTransitionOfModels]` proof, then assign `hthetaN := hthetaN'`. This fixes the dependent target before record construction and avoids re-elaborating the large `Q`/triple expression under the constructor. Bind `hOpen'` similarly; `glueData` must convert it back to the raw assembly type.

If that remains slow, isolate the triple producer in a named helper returning its exact existential output. That is the likely dominant cone; the wrapper primarily provides an elaboration/cache boundary rather than changing mathematics.
