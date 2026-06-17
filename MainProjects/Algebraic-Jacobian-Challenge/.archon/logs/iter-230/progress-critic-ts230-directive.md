# progress-critic ts230 — directive

Assess convergence of the single active prover route below. Fresh-context read of trajectory
only — do NOT read STRATEGY.md / blueprint / iter sidecars.

## Active route — A.1.c.SubT ⊗-inverse substrate (`Picard/TensorObjSubstrate.lean`)

The ⊗-group-law substrate: build `exists_tensorObj_inverse` (the line-bundle dual is invertible)
via a sheaf-internal-hom "descent re-route". The route reframed at iter-229: its two remaining
bridges (C-bridge `dual_isLocallyTrivial`, A-engine `homOfLocalCompat`) were found to reduce to
ONE shared Mathlib-absent root — the open-immersion↔slice sheaf-site equivalence. iter-229 built
that shared root.

### Strategy estimate (verbatim from STRATEGY.md `## Phases & estimations`)
- Route entered its current "descent / shared-root" phase at **iter-219**.
- `Iters left` estimate: **~3–5** (post-iter-229: C-transport 1–2 · A-engine 1–2 · assembly 1).
  (Was ~5–9 at iter-229 entry; decremented because the shared root landed in 1 iter.)

### Last 4 iters' signals (project sorry counter, decls/helpers added, prover status, blocker)
- **iter-226**: project sorry **80→80**. +1 decl (`isIso_of_isIso_restrict`, B-connector, axiom-clean,
  OFF critical path). Prover PARTIAL. Blocker phrase: "A+C bridges still remain for inverse."
- **iter-227**: project sorry **80→80**. +3 decls (`homMk`, `toPresheaf_map_homMk`,
  `restrictScalarsRingIsoDualEquiv` — A step ii + C shadow, axiom-clean). Prover PARTIAL. Blocker:
  "A-engine `homOfLocalCompat` is a ~120–190 LOC gluing build; did not land."
- **iter-228**: project sorry **80→80**. +3 decls (3 dual-iso helpers, axiom-clean). Prover PARTIAL.
  Blocker: "C-bridge `dual_isLocallyTrivial` GENUINELY hard-blocked at H2′ — the 'verbatim mirror'
  claim empirically falsified (dual is the SLICE internal hom, not a sectionwise restrictScalars-image)."
- **iter-229**: project sorry **80→80**. +3 decls (`overSliceSheafEquiv` shared root +
  `overEquivInverseIsDenseSubsite` + a private cover-correspondence, all axiom-clean). Prover PARTIAL
  (met its stated bridge-only success bar). Blocker phrase: "consumers NOT wired onto the root yet —
  convergence (a consumer → 80→79) is iter-230's test."

Background (pre-window): project sorry has been **80, flat, since iter-217** (when
`tensorObj_restrict_iso` closed 81→80). So this is the 13th iter at 80.

### Distinguishing feature of iter-229 vs 226–228
iter-226–228 were peripheral-helper accretion (helpers added, residual unchanged). iter-229
differs: it built the *load-bearing root* the route was explicitly reframed around (not a helper),
axiom-clean, and the root is value-category-parametric so one build is claimed to serve both
consumers. But the project counter has still not moved.

## Planner's proposed iter-230 objective (1 file)
- **`Picard/TensorObjSubstrate.lean`** [prover-mode: mathlib-build]: wire `overSliceSheafEquiv` into
  a consumer — PRIMARY the C-bridge `dual_isLocallyTrivial` (residual precisely identified iter-228,
  now discharged by the shared root + `restrictScalarsRingIsoDualEquiv` shadow); SECONDARY the
  A-engine `homOfLocalCompat`; if BOTH land, assemble `exists_tensorObj_inverse` (80→79). This is the
  decisive convergence datapoint — does a consumer actually close on the shared root?

## What I need from you
1. Verdict for this route (CONVERGING / CHURNING / STUCK / UNCLEAR), given iter-229 built a
   load-bearing root (not a helper) but the counter is still flat 13 iters.
2. Is the iter-230 objective (wire a consumer onto the root, targeting 80→79) the right move, or is
   it another "+helpers, residual unchanged" round in disguise?
3. If STUCK: name the corrective TYPE precisely. Note the binding constraint: the substrate is the
   SOLE ungated prover lane (all other routes are USER-paused or gated), so "pivot routes" is not
   available without a USER decision — the planner cannot idle the loop. Given that, what is the
   sharpest corrective and the sharpest tripwire for iter-230?
