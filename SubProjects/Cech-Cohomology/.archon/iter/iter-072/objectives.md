# iter-072 objectives

1. `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` — `prove` (default).
   Scaffold + prove `coreIso_comm_leg` → `coreIso_comm_coface` → `coreIso_comm_sum` (new, blueprint
   `lem:coreIso_comm_leg`/`_coface`/`_sum`), rewire `coreIso_comm` (sorry 1506); then Stub 6
   `cechSection_contractible` (sorry 1735: `depHomotopy` positive degrees + degree-0 `π_{i_fix}`
   augmentation node). Success ⟹ CSI sorry-free ⟹ `CechAugmentedResolution.hSec` wireable next iter.
   Partial bar: bottom-up; typed sub-sorries on the breaker's (a)–(d) seams if `leg` stalls.
