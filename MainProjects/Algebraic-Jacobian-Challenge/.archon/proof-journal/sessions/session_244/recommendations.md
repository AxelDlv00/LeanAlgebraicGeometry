# Recommendations — for the iter-245 plan agent

## Headline
- **D1 is DONE — do NOT re-dispatch `pullbackLanDecomposition`.** The 7 axiom-clean decls
  (`pullbackLanDecomposition`, `extendScalars`, `pullback0`, two adjunctions, two private
  `IsRightAdjoint` lemmas) landed and are independently axiom-clean. Review added the missing `\lean{}`
  pin so next `sync_leanok` marks it.
- **The canonical critical-path counter has now been FLAT for SIX iters (239–244).** This is a
  structural decision point, not a proof-search round. The remaining A.1.c content (D2 strong-monoidal
  `extendScalars`, D3 `pullback0_tensor_iso`) is confirmed Mathlib-scale — strategy-critic ts244
  estimated ~20–38 iters / ~400–750 LOC for the full build. The plan agent should make and RECORD a
  deliberate choice before dispatching (see Strategic decision below).

## Strategic decision the plan agent must make and record (iter-245)
Two routes are live; iter-244 committed to (A) but the iter-243 (B) reading remains un-rebutted by
evidence:

- **(A) Commit to the bottom-up general D2/D3 concrete-model build** as a dedicated multi-iter lane.
  The prover handed off the precise sub-lemma sequence:
  - **D2:** build a concrete pointwise `extendScalarsConcrete φ` over CommRingCat bases (value at `U` =
    `ModuleCat.extendScalars (φ.app U).hom`), give it `.Monoidal` via `AlgebraTensorModule.distribBaseChange`
    + naturality, then identify with the abstract `extendScalars φ` via `leftAdjointUniq` (both are
    `(restrictScalars φ).leftAdjoint`).
  - **D3 (the genuine content):** (i) identify `pullback0` on underlying Ab-presheaves with `Lan F.op`;
    (ii) pointwise Lan colimit over the up-directed comma category `(F↓V) = {U : f⁻¹V ⊆ U}`;
    (iii) filtered-colimit/⊗ interchange for `ModuleCat`-valued presheaves ⇒ `δ₀` iso. Anchor on
    `pullbackObjFreeIso` (Mathlib, pullback-of-free).
  - D4 + `IsInvertible.pullback` are then 3-line corollaries (`pullbackUnitIso`, `pullbackTensorMap`
    already in hand).
- **(B) Re-weigh the local-trivialization route that iter-243 demoted off-path.** It only needs the
  iso on the *invertible pair* (every downstream consumer pulls back only invertibles), which may
  sidestep the general concrete model. iter-243's "local-trivialization is cheaper" reading was never
  rebutted by evidence; D1 — which both routes consume — is now in hand. A `mathlib-analogist`
  cross-domain consult on "pointwise Lan model for an abstract left adjoint of presheaves" vs. the
  local route would sharpen this before committing 20+ iters.

**Either way: do NOT re-dispatch D2/D3 verbatim without committing to the multi-iter scope** — that
produces a seventh flat iter. A `progress-critic` dispatch is warranted next plan phase given the
6-iter flat counter (the route is not CHURNING — genuine bricks land — but the planner should hear a
fresh-context read before committing the multi-iter lane).

## Review-subagent findings (iter-244)

### MAJOR (lean-auditor ts244) — file-header causal claim is wrong (introduced THIS iter)
- `TensorObjSubstrate.lean:43–46` — the iter-244 docstring cleanup introduced a false causal "so":
  it claims `isLocallyInjective_whiskerLeft_of_W` being closed iter-237 is *why* `tensorObj_assoc_iso`
  is unconditional. The actual ROUTE (d) proof (L321–361) does NOT use that lemma — it goes through
  Mathlib's `W_whisker*` lemmas independently. **Action:** next prover-touch of this file should fix the
  header to state ROUTE (d) is independent of the ROUTE (e) ingredient. (Plan agent cannot edit `.lean`;
  fold into the next prover objective for this file as a no-risk comment fix.)
- **Related stale comment (cross-file, Vestigial.lean):** its header still says
  `isLocallyInjective_whiskerLeft_of_W` is "one open sorry" (it's axiom-clean since iter-237), and its
  docstring calls that lemma "the single residual ingredient of `tensorObj_assoc_iso` under ROUTE (d)"
  — also stale (ROUTE (d) doesn't use it). Fold into a Vestigial.lean comment-cleanup objective.

### MAJOR (lean-vs-blueprint-checker ts244) — orphaned `\lean{}` pin — FIXED THIS ITER
- `lem:tensorobj_isoclass_commgroup` (L2366) pinned the non-existent `tensorObjIsoclassCommMonoid`
  (refactored into `PicGroup` + `picCommGroup`). **Review corrected the pin this iter** to
  `\lean{...PicGroup, ...picCommGroup}` + a `% NOTE:`. No further action needed.

### MAJOR (lean-auditor ts244) — deprecated `Sheaf.val` API (accumulating debt)
- `TensorObjSubstrate.lean` — 34 occurrences of `CategoryTheory.Sheaf.val` (deprecated → `ObjectProperty.obj`).
  Non-blocking today, but a hard break on a future Mathlib bump. **Action:** schedule a mechanical
  `.val → ObjectProperty.obj` sweep (refactor subagent or a prover comment-pass) before any Mathlib
  bump. Not urgent this iter.

### MINOR
- `TensorObjSubstrate.lean:483–485` — three >100-char lines (linter). Cosmetic.
- `pullbackObjUnitToUnit_comp` (L902–988) — 5× `erw` where `rw` fails on defeq-not-syntactic
  `SheafOfModules` composition; explained and acceptable, candidate for simplification if Mathlib adds
  syntactic-form lemmas.
- (lean-vs-blueprint) D1 carrier decls `pullback0`/`extendScalars`/their adjunctions lack `\lean{}`
  pins — adding them would aid D2/D3 navigation. Plan agent could add anticipatory pins (or sub-lemma
  blocks) when blueprinting the D2/D3 build.

## Blocked targets — do NOT re-assign as a single-session close
- `pullback0TensorIso` (D3) and `pullbackTensorIso` (D4): Mathlib-scale, multi-hundred-LOC. Only as a
  committed multi-iter lane with the bottom-up sub-lemma sequence above.
- `IsInvertible.pullback`, `IsInvertible.isLocallyTrivial`: gated on D2/D3 (or on route B).
- `exists_tensorObj_inverse` (L694), `addCommGroup_via_tensorObj` (L1331): the two deferred dual-bridge
  sorries — unchanged, blocked on their documented C/A bridges; not this lane's target.

## Reusable proof patterns discovered
- **`restrictScalars (𝟙 R) ≡ 𝟭` defeq** (memory `restrictscalars-id-defeq`): lets `pushforward₀` and
  `restrictScalars` be recognized as `pushforward` instances via `inferInstanceAs`, so their
  `leftAdjoint`s exist. Pin the ring presheaf explicitly (`(R := …)`) or the `F` metavariable won't
  resolve.
- **`Adjunction.leftAdjointCompIso` fed `Iso.refl` of a definitional composite** derives a left-adjoint
  decomposition iso from a right-adjoint composite identity. Reusable for any `G = G₀ ⋙ G₁` definitional
  factorization where each factor is a right adjoint.
- **Namespace shadowing:** inside `AlgebraicGeometry.Scheme.Modules`, write `_root_.PresheafOfModules`
  in type position (member projection unaffected).
