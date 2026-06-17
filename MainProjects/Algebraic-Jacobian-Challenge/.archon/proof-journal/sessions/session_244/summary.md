# Session 244 — review of iter-244

## Metadata
- **Iteration / session:** 244
- **Prover lanes:** 1 (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, mode `mathlib-build`, A.1.c critical path).
- **File sorry count:** 2 → 2 (unchanged). The two are the deferred dual-bridge sorries
  `exists_tensorObj_inverse` (~L694) and the `addCommGroup`-scaffold (~L1331), both UNTOUCHED.
- **Canonical critical-path counter:** flat (no pre-existing canonical sorry eliminated). This is the
  SIXTH consecutive flat-counter iter (239–244) — bricks land each iter, the canonical sorries do not move.
- **Build:** GREEN (file error-free, `lean_diagnostic_messages` clean).
- **Axioms (re-verified first-hand):** `pullbackLanDecomposition` → `{propext, Classical.choice, Quot.sound}`.
  The `lean_verify` "opaque" source flag at L467 is the word "opaque" inside a prose comment
  (verified by reading L462–471) — NOT laundering.
- **sync_leanok:** iter 244, sha `1381b961`, **+0 / −0**, chapters_touched `[]`. No marker movement —
  expected, because the new D1 lemma had no `\lean{}` pin in the chapter when sync ran (the prover
  self-named the decl per objectives). Review added the pin this iter (see Blueprint markers below) so
  next iter's sync can mark it.

## Target: `pullbackLanDecomposition` (D1 of the general strong-monoidal pullback build) — PARTIAL (landed)

The objective was to land D1 — the most self-contained brick of
`sec:tensorobj_pullback_monoidality` (`lem:pullback_lan_decomposition`) — then proceed to D2/D3 if
reachable. **D1 landed as 7 axiom-clean declarations** in a new `PullbackLanDecomposition` section
(file end, ~L1257–1330) inside `namespace AlgebraicGeometry.Scheme.Modules`:

- `pushforward₀IsRightAdjoint` (private lemma)
- `restrictScalarsIsRightAdjoint` (private lemma)
- `pullback0` (def) — the topological inverse image `(pushforward₀ F R).leftAdjoint`
- `extendScalars` (def) — `(restrictScalars φ).leftAdjoint`
- `pullback0Adjunction` (def) — `pullback0 F R ⊣ pushforward₀ F R`
- `extendScalarsAdjunction` (def) — `extendScalars φ ⊣ restrictScalars φ`
- `pullbackLanDecomposition` (def) — **D1**: `pullback φ ≅ extendScalars φ ⋙ pullback0 F R`

### Attempts (from `attempts_raw.jsonl`)

1. **`example : (pushforward₀ Fx Rx).IsRightAdjoint := by infer_instance`** (L1249) →
   *failed*: `failed to synthesize instance (pushforward₀ Fx Rx).IsRightAdjoint`. Plain
   `infer_instance` does not see through `pushforward₀` to the general `pushforward` instance.
2. **`inferInstanceAs (pushforward (𝟙 (Fx.op ⋙ Rx))).IsRightAdjoint`** for `pushforward₀`, and
   `pushforward (F := 𝟭 C) φ` for `restrictScalars` → *partial*: pushforward₀ case resolved; the
   restrictScalars case errored `failed to synthesize (pushforward ?m.34).IsRightAdjoint` — the `F`
   metavariable was not pinned.
3. **Add explicit `(R := Fx.op ⋙ Rx)`** to the restrictScalars bridge → *success* (clean diagnostics).
   **Key enabling discovery:** `restrictScalars (𝟙 R)` is *definitionally* `𝟭`, witnessed by Mathlib's
   `instance : (restrictScalars (𝟙 R)).Full := inferInstanceAs (𝟭 _).Full`
   (`ModuleCat/Presheaf/ChangeOfRings.lean`). So `pushforward₀ F R` is defeq `pushforward (𝟙 (F.op⋙R))`
   and `restrictScalars φ` is defeq `pushforward (F := 𝟭 C) φ` — both then reachable from the general
   `instance : (pushforward φ).IsRightAdjoint` (`Pullback.lean:97`).
4. **Assemble `pullbackLanDecomposition` via `Adjunction.leftAdjointCompIso`** fed `Iso.refl (pushforward φ)`
   (the factorisation `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ` is *definitional*,
   Mathlib `Pushforward.lean:86`) → *success* after fixing a namespace-shadowing type mismatch:
   inside `namespace …Scheme.Modules` the bare type `PresheafOfModules` is shadowed (resolves to a
   Scheme-indexed thing); type-position uses need `_root_.PresheafOfModules` (member access
   `PresheafOfModules.pushforward₀` is fine). All three of `pullbackLanDecomposition`,
   `extendScalars`, `pullback0` verified `{propext, Classical.choice, Quot.sound}` individually.

### Why the prover stopped at the D2/D3 boundary

Both D2 (`extendScalars` strong monoidal) and D3 (`pullback0_tensor_iso`, the genuine content)
require a **concrete pointwise model** of the abstract `.leftAdjoint` functors, which is genuinely
Mathlib-absent at the pinned commit:
- **D2:** Mathlib's `ModuleCat.extendScalars f` is `.Monoidal` (via `AlgebraTensorModule.distribBaseChange`),
  but the prover's `extendScalars φ = (restrictScalars φ).leftAdjoint` is *abstract* — it exposes no
  sectionwise value, so `distribBaseChange` cannot be invoked without first building a concrete
  pointwise presheaf-level `extendScalarsConcrete φ` (over CommRingCat bases) and identifying it via
  `leftAdjointUniq`. The "oplax for free" route (`leftAdjointOplaxMonoidal`) gives only oplax, not the
  strong tensorator the δ-iso reduction needs.
- **D3:** `pullback0` is the abstract `(pushforward₀ F R).leftAdjoint` with no pointwise Lan colimit
  formula exposed; the δ₀ iso needs the pointwise Lan model over the up-directed comma category plus
  filtered-colimit/⊗ interchange for `ModuleCat`-valued presheaves.

The prover correctly left D2/D3/D4 + `IsInvertible.pullback` ABSENT with **no sorry pin** (mathlib-build
invariant), and handed off precise next sub-lemmas. Informal agent not consulted: the blocker is a
known structural Mathlib gap, not a proof-search problem.

### Secondary cleanup (lean-auditor ts243 majors) — DONE, no proof risk
- `tensorObj_assoc_iso` docstring rewritten to the UNCONDITIONAL ROUTE (d) (stale flatness text struck).
- File-header stale claim that `isLocallyInjective_whiskerLeft_of_W` is an open sorry-residual removed
  (it closed iter-237 in `Vestigial.lean`).

## Key findings / patterns
- **`restrictScalars (𝟙 R) ≡ 𝟭` defeq** is the enabling lever: it makes both `pushforward₀` and
  `restrictScalars` recognizable as `pushforward` instances, so their right-adjointness (and hence the
  existence of `pullback0`/`extendScalars` as `.leftAdjoint`) is `inferInstanceAs`-reachable. Recorded
  in memory as `restrictscalars-id-defeq`.
- **`Adjunction.leftAdjointCompIso` on a definitional composite** (fed `Iso.refl`) is a clean way to
  derive a left-adjoint decomposition iso from a right-adjoint composite identity — reusable.
- **Namespace shadowing:** inside `AlgebraicGeometry.Scheme.Modules`, use `_root_.PresheafOfModules`
  in type position; member projection is unaffected.

## Recommendations for next session
See `recommendations.md`. Headline: D1 is the EASY leg; the canonical Picard counter cannot move until
D2+D3 — a confirmed Mathlib-scale sub-build — land. iter-245 should either commit to the bottom-up
D2/D3 concrete-model build as a dedicated multi-iter lane (with the precise sub-lemma sequence the
prover handed off) or re-weigh the local-trivialization route that iter-243 demoted. Do NOT re-dispatch
D1 — it is done.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:pullback_lan_decomposition`: added
  `\lean{AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition}` (prover self-named the decl per
  objectives; no pin existed). Statement is axiom-clean and sorry-free, so next iter's `sync_leanok`
  will add `\leanok`.
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_isoclass_commgroup`: corrected stale pin
  `\lean{...tensorObjIsoclassCommMonoid}` (non-existent decl) → `\lean{...PicGroup, ...picCommGroup}`
  + a `% NOTE:` (the monolith was refactored into carrier + group law; flagged MAJOR by
  lean-vs-blueprint-checker ts244, pre-existing).

## Blueprint doctor
CLEAN — no structural findings (all chapters `\input`'d, all `\ref`/`\uses` resolve, no `axiom` decls).

## Review subagents
- `lean-auditor` (ts244) and `lean-vs-blueprint-checker` (ts244) dispatched — findings landed in
  `recommendations.md`.
