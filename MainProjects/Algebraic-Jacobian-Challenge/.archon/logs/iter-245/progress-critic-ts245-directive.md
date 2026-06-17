# Progress-critic directive — iter-245

Assess convergence of the single active prover route. Verdict per route.

## Route A.1.c.sub — `Picard/TensorObjSubstrate.lean` (critical path: substrate `IsInvertible.pullback`)

**Route status framing (signal, not strategy):** As of iter-244 this route is a COMMITTED
multi-iter `mathlib-build` of a Mathlib-absent piece of infrastructure (a concrete
strong-monoidal inverse-image pullback for presheaves of modules). The build was deliberately
chosen iter-244 *as the corrective* to your own prior-iter CHURNING verdict, which prescribed
"route pivot, not a 6th surface route." The build is decomposed into D1→D2→D3→D4 then a 3-line
corollary. The file's canonical sorry count (2) is EXPECTED to stay flat for the duration of the
build — those 2 sorries are deferred dual-bridge obligations off this route; the build's payoff
sorry-closure only lands at the very end (D4 + corollary). So "flat canonical counter" is the
designed shape here, not necessarily a churn signal — your job is to judge whether the build is
making genuine *structural* progress brick-by-brick, or whether "commit to a 20-38-iter build" is
relabeling a stall.

**Per-iter signals (last 4 iters):**

- iter-241: file sorry 2→2. Landed `pullbackUnitIso` (`f^*𝒪≅𝒪`, axiom-clean) + 3 supporting bricks. Status PARTIAL. Blocker phrase: "general `pullbackTensorIso` Mathlib-scale".
- iter-242: file sorry 2→2. Landed 2 axiom-clean presheaf instances (`presheafPushforwardLaxMonoidal`, `presheafPullbackOplaxMonoidal` = the comparison MAP δ). Status PARTIAL. Blocker phrase: "concrete-P route Mathlib-scale".
- iter-243: file sorry 2→2. Landed `pullbackTensorMap` (sheaf-level δ MAP) + `pullbackValIso` (axiom-clean). Status PARTIAL. Blocker phrase: "forward-bridge / extendScalars Mathlib-scale".
- iter-244: file sorry 2→2. Landed **D1 = 7 axiom-clean declarations** (`pullbackLanDecomposition` = the functorial iso `pullback φ ≅ extendScalars φ ⋙ pullback₀`, plus the 2 carrier functors `extendScalars`/`pullback0`, their 2 adjunctions, 2 private right-adjoint lemmas). Status PARTIAL. Blocker phrase: "D2/D3 concrete pointwise model Mathlib-absent".

**Strategy estimate for this route:** Iters-left ≈ 20–38; phase (committed build) ENTERED iter-244
(this is the 1st full build iter; D1 is its first brick).

**This iter's proposed objective:** 1 file — `TensorObjSubstrate.lean`, continue the committed build
with **D2** (build a concrete pointwise `extendScalars` model over CommRingCat bases — value at U is
`ModuleCat.extendScalars (φ.app U).hom` — give it strong-monoidal via Mathlib `distribBaseChange`
pointwise + naturality, then identify with the abstract `extendScalars φ` via `leftAdjointUniq`).
The prover handed off this exact next sub-lemma at the end of iter-244.

## What I need from you

1. Verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) for route A.1.c.sub, with the specific signals
   you base it on. In particular: is the D1→D2 progression genuine brick-by-brick build convergence,
   or is the "committed 20-38-iter build" framing a way to keep a stalled route alive? Distinguish
   "lands new axiom-clean infrastructure each iter that is *on the build's named decomposition path*"
   (convergence) from "lands new helpers each iter that orbit an unmoving target" (churn).
2. If CHURNING/STUCK, name the corrective TYPE.
3. Dispatch-sanity: the proposed objective list is 1 file. Flag if that's wrong.
