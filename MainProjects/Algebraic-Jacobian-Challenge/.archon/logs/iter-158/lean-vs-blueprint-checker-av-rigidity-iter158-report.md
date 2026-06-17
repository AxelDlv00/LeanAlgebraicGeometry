# Lean ↔ Blueprint Check Report

## Slug
av-rigidity-iter158

## Iteration
158

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Headline finding (directive items 2 & 3)

**The iter-157 unsoundness is REPAIRED. The `% NOTE (iter-157 review)` block in the
blueprint proof of `thm:rigidity_lemma` (tex lines 85–95) is now STALE and actively
misleading — it must be removed/updated by the review agent.**

Evidence:
- `rigidity_eqOn_dense_open` (Lean 111) now **carries** `_hf` (Lean 121) and **consumes**
  it: `hy₀` derives `y₀pt ∉ Gset` via `exact congrArg Over.Hom.left _hf` (Lean 161),
  exactly Mumford's "`y₀ ∉ G` since `f(X×{y₀}) = {z₀}`" step. Drop `_hf` and `hy₀` cannot
  be proven — the non-emptiness witness collapses.
- `rigidity_core` (Lean 243) carries `_hf` (Lean 253) and threads it:
  `rigidity_eqOn_dense_open f x₀ y₀ z₀ _hf` (Lean 261).
- `rigidity_lemma` (Lean 324) carries `_hf` (Lean 334) and consumes it:
  `exact rigidity_core f x₀ y₀ z₀ _hf` (Lean 341).
- Compiler confirms (`lean_diagnostic_messages`): `sorry` warnings appear ONLY at lines
  111, 357, 381, 406. **No `sorry` at line 243 (`rigidity_core`) or line 324
  (`rigidity_lemma`)** — both close fully modulo the single deferred
  `rigidity_eqOn_dense_open`. A proof that "laundered" `_hf` (the iter-157 tell) is
  impossible here because the lower helper now *uses* it.
- Soundness sanity check: the old `f = fst` counterexample no longer satisfies the
  antecedent — `_hf` for `f = fst` would force `𝟙 X = toUnit X ≫ z₀`, false for
  nontrivial `X`. The statement is now genuinely conditioned on the collapse hypothesis.

This matches the blueprint's now-explicit insistence (`rmk:rigidity_lemma_decomposition`
tex 144–147; `lem:rigidity_eqOn_dense_open` "load-bearing" para tex 179–187) that `_hf`
be threaded through all three helpers. **Lean and blueprint prose are now consistent.**

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (chapter: `thm:rigidity_lemma`)
- **Lean target exists**: yes (Lean 324).
- **Signature matches**: yes. Conclusion `∃ g : Y ⟶ Z, f = snd X Y ≫ g` matches "∃ g, f =
  g ∘ p₂". The Lean adds `x₀` and the `GeometricallyIrreducible (X⊗Y).hom` / `IsReduced
  (X⊗Y).left` / `IsSeparated Z.hom` instances and `_hf`; these are the precise "complete
  *variety* X, *varieties* Y,Z" hypotheses the blueprint statement and the iter-157
  signature-correction docstring (Lean 288–298) call for, and are consistent with Milne's
  Rigidity Theorem 1.1 cited in `rmk:rigidity_lemma_cube_free`. Not a mismatch.
- **Proof follows sketch**: yes. Mumford witness `g(y)=f(x₀,y)` (Lean 337), reassociate +
  `rigidity_snd_lift` collapse (Lean 339), then geometric core (Lean 341) — mirrors the
  blueprint proof structure.
- **notes**: fully proven modulo `rigidity_eqOn_dense_open`. `_hf` consumed.

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (chapter: `lem:rigidity_eqOn_dense_open`)
- **Lean target exists**: yes (Lean 111).
- **Signature matches**: yes. Existential of a non-empty open `U` with `U.ι ≫ f.left =
  U.ι ≫ (retract ≫ f).left`, `retract = lift (toUnit (X⊗Y) ≫ x₀) (snd X Y)` — matches the
  blueprint's `U = X×V`, agreement of `f` with `retract ; f`. Collapse hypothesis carried
  verbatim in the encoding the lemma statement specifies (tex 169–170).
- **Proof follows sketch**: partial — by construction, this is where the geometry is
  deferred. `G = p₂(f⁻¹(Z∖U₀))` closed via `snd_left_isClosedMap` (Lean 142), `y₀∉G` from
  `_hf` (Lean 156–166), non-emptiness witness `s x₀pt` over `y₀∈V` (Lean 168–176) — all
  matching the blueprint proof. Two `sorry`s remain (see Red flags / adequacy).
- **notes**: the load-bearing role of `_hf` is honored exactly as the blueprint demands.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chapter: `prop:morphism_P1_to_AV_constant`)
- **Lean target exists**: yes (Lean 357).
- **Signature matches**: yes. `P1` encoded as `SmoothOfRelativeDimension 1` + `IsProper` +
  `GeometricallyIrreducible` + `genus = 0` (the project's abstract ℙ¹ proxy, per docstring);
  `A` abelian variety; conclusion `∃ a₀, f = toUnit P1 ≫ a₀` matches "f constant".
- **Proof follows sketch**: N/A — body is `sorry` (scaffold). Blueprint proof explicitly
  defers the base case to `thm:theorem_of_the_cube`, which carries **no** Lean target
  (deferred deep input). Honestly scaffolded, not deceptive.
- **notes**: expected scaffold `sorry`; blueprint transparently marks the cube as the
  un-built prerequisite.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: `prop:genusZero_curve_iso_P1`)
- **Lean target exists**: yes (Lean 381).
- **Signature matches**: yes. Two genus-0 smooth-proper-geom-irred curves are isomorphic
  in `Over (Spec k̄)` (`Nonempty (C ≅ P1)`), matching "C ≅ ℙ¹" under the ℙ¹-as-proxy
  encoding.
- **Proof follows sketch**: N/A — body is `sorry` (scaffold). Blueprint `rmk:genusZero_iso_subbuild`
  explicitly flags this as a genuine Riemann–Roch sub-build absent from Mathlib.
- **notes**: expected scaffold `sorry`.

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chapter: `thm:rigidity_genus0_curve_to_AV`)
- **Lean target exists**: yes (Lean 406).
- **Signature matches**: yes — pinned verbatim to `rigidity_over_kbar` minus `[CharZero kbar]`
  (no `CharZero` instance present; conclusion `f = toUnit C ≫ η[A]`, pointed hypothesis
  `p ≫ f = η[A]`). Matches blueprint statement and "verbatim except `[CharZero]`" claim.
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint proof composes
  `genusZero_curve_iso_P1` + `morphism_P1_to_grpScheme_const` + pointed pin; both inputs
  are themselves deferred, so this terminal scaffold is honest.
- **notes**: the headline consumed by `genusZeroWitness`; awaits its two inputs.

## Helper declarations not referenced by `\lean{...}` (informational)

- `rigidity_snd_lift` (Lean 64): cartesian-monoidal algebra step. PROVEN, axiom-clean
  (`ext1 <;> simp`). Described in prose at `rmk:rigidity_lemma_decomposition` but has no
  dedicated `\lean{}` block. Acceptable helper; could optionally be promoted. Minor.
- `snd_left_isClosedMap` (Lean 83): "bridge 1" closed-map step. PROVEN. Described in prose
  (blueprint proof tex 203–204 and `rigidity_core` docstring) but no `\lean{}` block.
  Acceptable helper. Minor.

Both helpers' signatures match the prose roles assigned to them; neither is fake or
placeholder.

## Red flags

### Placeholder / `sorry` bodies
- `rigidity_eqOn_dense_open` (Lean 154, `hfib`) and (Lean 181, agreement equation): the two
  documented geometric `sorry`s. These are honestly isolated and commented as the deferred
  inputs (pullback-fibre identification; relative proper-into-affine constancy). **Not
  deceptive** — see adequacy below.
- `morphism_P1_to_grpScheme_const` (Lean 357), `genusZero_curve_iso_P1` (Lean 381),
  `rigidity_genus0_curve_to_grpScheme` (Lean 406): scaffold `sorry`s. Each declaration's
  docstring carries an explicit `**Status**: iter-157 scaffold — body is sorry`, and the
  blueprint defers each (cube / Riemann–Roch sub-build / downstream of the two). Transparent
  scaffolds, not laundered proofs.

No `:= True`, `:= rfl`-on-nontrivial, `Classical.choice`, or `axiom` declarations found.
No excuse-comments masking wrong code.

### Stale blueprint note (actively misleading) — see Headline
- Blueprint tex 85–95: the `% NOTE (iter-157 review)` block asserts the Lean is "UNSOUND as
  landed", `_hf` "DROPPED", "never consumes `_hf` — the tell". **All three claims are now
  false** against the iter-158 Lean. This is not benign drift: a future reader/agent would
  conclude the proof is broken when it has been correctly repaired. Review-agent–owned
  marker (`% NOTE:`).

## Blueprint adequacy for this file

- **Coverage**: 5/5 substantive declarations (`rigidity_lemma`, `rigidity_eqOn_dense_open`,
  `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
  `rigidity_genus0_curve_to_grpScheme`) have `\lean{...}` blocks. 2 helpers
  (`rigidity_snd_lift`, `snd_left_isClosedMap`) are prose-described but unreferenced —
  acceptable.
- **Proof-sketch depth**: adequate. The `lem:rigidity_eqOn_dense_open` proof (tex 200–215)
  previews the closed-map step, the `y₀∉G`-from-collapse step, and the proper-into-affine
  single-point step. The second Lean `sorry` (agreement equation, Lean 181) is honestly the
  "proper-into-affine ⇒ constant" bridge the prose names. The `rigidity_core` docstring
  (Lean 206–242) gives the two-bridge Mathlib entry points beyond what the prose has to.
- **One gap (minor):** the first Lean `sorry` `hfib` (Lean 154) — that the scheme fibre
  `p₂⁻¹{y₀}` lies in the range of the slice section `s : X → X⊗Y` — is a Lean-encoding
  obligation (identifying `X×{y₀}` with the pullback fibre over the `k̄`-point `y₀`). The
  blueprint prose treats `X×{y₀}` as literally the fibre and so does not flag this
  identification. Textbook-honest, but the chapter could add one clause noting the
  slice-as-fibre identification as a formalization step. Does not rise to under-specified.
- **Hint precision**: precise. Each `\lean{...}` names the exact declaration; signatures
  match prose.
- **Generality**: matches need. The added `GeometricallyIrreducible`/`IsReduced`/`IsSeparated`
  instances on `rigidity_lemma` are now mirrored in the blueprint prose (variety hypotheses,
  Milne Rigidity 1.1), and `rmk:rigidity_lemma_decomposition` documents the `_hf`-threading
  requirement that the Lean now satisfies.
- **Recommended chapter-side actions**:
  - **Remove or rewrite** the stale `% NOTE (iter-157 review)` block (tex 85–95): the Lean
    now threads and consumes `_hf`; `rigidity_core`/`rigidity_lemma` are sorry-free. Replace
    with a one-line "iter-158: `_hf` threaded; sound" note if any marker is desired.
  - (Optional, minor) add a clause to the `lem:rigidity_eqOn_dense_open` proof noting the
    slice `X×{y₀}` = scheme fibre over the `k̄`-point `y₀` identification (the `hfib` step).
  - (Optional, minor) consider `\lean{}` blocks for `rigidity_snd_lift` and
    `snd_left_isClosedMap`, both proven.

## Severity summary

- **must-fix-this-iter**: none introduced by this check. The iter-157 must-fix
  (`_hf`-dropping unsoundness) is **RESOLVED** in the Lean.
- **major**:
  - Stale & actively-misleading `% NOTE (iter-157 review)` block (blueprint tex 85–95)
    claiming the Lean is unsound. Review agent should update/remove it. (Blueprint-side,
    not blocking the Lean.)
- **minor**:
  - `hfib` slice-as-fibre identification not previewed in blueprint prose.
  - `rigidity_snd_lift` / `snd_left_isClosedMap` proven but unreferenced by `\lean{}`.

Overall verdict: the iter-157 unsoundness is genuinely repaired — `_hf` is threaded through
and consumed by all three helpers, `rigidity_core`/`rigidity_lemma` are now sorry-free, and
all five `\lean{...}` signatures match the blueprint; the only outstanding action is that
the blueprint's `% NOTE (iter-157 review)` unsoundness block is now stale and must be
retired by the review agent.
