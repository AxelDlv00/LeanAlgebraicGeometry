# Iter-227 objectives (detail)

## Lane TS — `Picard/TensorObjSubstrate.lean` [mathlib-build] — TERMINAL GRACE WINDOW

**Context:** progress-critic ts227 = STUCK + OVER_BUDGET. iter-226 landed the B-connector
(`isIso_of_isIso_restrict`, off-critical-path). This iter must produce the FIRST critical-path bridge
(A) axiom-clean, or surface the C/d.2 blocker decisively, else the RR-fork escalates next iter.

### PRIMARY — A-bridge `Scheme.Modules.homOfLocalCompat` (axiom-clean, ~30–60 LOC)
- Statement: open cover `{Uᵢ}` of `X`, `M N : X.Modules`, compatible `fᵢ : M|_{Uᵢ} ⟶ N|_{Uᵢ}`
  (agree on `Uᵢ ∩ Uⱼ`) ⇒ unique global `f : M ⟶ N` restricting to each `fᵢ`.
- Route (blueprint `lem:sheafofmodules_hom_of_local_compat`, analogist ts226descent §A):
  1. forget to ab-sheaf via `SheafOfModules.toSheaf R` (faithful + additive);
  2. glue ab-morphism via `Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv` (`Sites/SheafHom.lean`);
  3. promote to 𝒪_X-linear via `PresheafOfModules.homMk` (sectionwise linearity, separated presheaf).
- Verify exact Mathlib names/sigs via `lean_local_search`/`lean_hover_info` before committing
  (the `:207,241`/`:200`/`:89` line refs are [expected], not [verified]).

### SECONDARY — C-bridge PROBE (decisive, cheap; do NOT full-build)
- Crux: `(dual M).restrict f ≅ dual(M.restrict f)` for open immersion `f`.
- Question: does the presheaf step assemble via `restrictScalarsEquivalenceOfRingEquiv` carrying
  `Hom(-,-)`/dual across `f.appIso` (genuine d.2-free mirror of `tensorObj_restrict_iso`), OR does it
  re-require a tensor/internal-hom stalk commutation (d.2)?
- DELIVERABLE: explicit verdict in `task_results/` (the iter-228 escalation-tripwire input).

### Ride-along (comment hygiene — lean-auditor ts226)
- (a) fix file-header pin #3 (L69–73, non-existent `monoidalCategory`);
- (b) rewrite stale `exists_tensorObj_inverse` docstring "iter-218 gate" block (L1987–2003);
- (c) fix stale "at L1349" cross-ref (L2002 → 1912).

### Success bar
A-bridge axiom-clean + explicit C-probe verdict = full success. NO sorry pins into new decls. 80→79
NOT expected. If A cannot land axiom-clean → report the blocker (do not stub) → route escalates.

## Held lanes
RPF, FGA, A.2.c engine, Albanese (Route 1 + 2), WD, RCI, A.3.* — all HELD per documented gates /
USER ROUTE C PAUSE. No dispatch.
