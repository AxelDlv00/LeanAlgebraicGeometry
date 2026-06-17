# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review130

## Iteration
130

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` § "Piece (i): sub-lemma decomposition for iter-128+ build" (subsec:RigidityKbar_piece_i_decomposition)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: `lem:GrpObj_cotangentSpace`)
- **Lean target exists**: yes — `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` at `GrpObj.lean:131`.
- **Signature matches**: yes — Lean signature `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k` matches the blueprint stub at lines 100–102 verbatim. The dualisation convention pinned in the iter-129 encoding note (line 109: returns un-dualised `𝔤^∨`) matches the Lean docstring at lines 76–94.
- **Proof follows sketch**: yes — the blueprint `\begin{proof}` block (lines 112–122) describes exactly the iter-130 Replacement (B) chart-base-change construction the Lean body realises:
  - Chart extraction via `smooth_locally_free_omega` (line 115 ↔ Lean `GrpObj.lean:147–148`).
  - Algebra structure on `Γ(G, V)` from `appLE` on `G.hom` (line 115 ↔ Lean `GrpObj.lean:162–163`).
  - Construction of `ψ_V : Γ(G, V) → k` from restricted identity section composed with `Scheme.ΓSpecIso` (line 115 ↔ Lean `GrpObj.lean:158–159`).
  - Base change of the algebraic Kähler module via `ModuleCat.extendScalars` (lines 116–119 ↔ Lean `GrpObj.lean:169–170`).
- **`Classical.choice` opacity caveat**: present — the blueprint `Caveat on canonicity` paragraph (lines 121) explicitly acknowledges "The construction depends on a chart choice $V$ extracted via `Classical.choice` from the existential statement of `smooth_locally_free_omega`; it is therefore not canonically attached to $G$ in the strictest sense." This aligns with the Lean docstring `**Caveat on canonicity**` at lines 118–126 and the inline comment at `GrpObj.lean:140–142`.
- **notes**: All four Mathlib closure-chain names (`smooth_locally_free_omega`, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`, `Module.finrank_baseChange`, `Algebra.TensorProduct.instFree`) appear in the chapter — three of them in `lem:GrpObj_cotangentSpace` body, the rank-side two (`finrank_baseChange`, `instFree`) in the `lem:GrpObj_lieAlgebra_finrank` proof's iter-130 closure-path paragraph at line 203. `Algebra.IsStandardSmooth.free_kaehlerDifferential` is named at line 203 as well; not directly used in the Lean body (the body only invokes `smooth_locally_free_omega` which packages this internally), so its mention is preparatory for the deferred rank lemma rather than load-bearing here.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}` (chapter: `lem:GrpObj_cotangent_bridge`)
- **Lean target exists**: no — declaration not present in the audited file. This is expected: the lemma is marked `\notready` (line 137) and deferred to iter-130+ build.
- **Signature matches**: N/A (Lean target intentionally absent).
- **Proof follows sketch**: N/A (Lean target intentionally absent).
- **`\notready` marker**: present (line 137). ✓
- **notes**: See "Red flags" below — the proof sketch's Step 1 still describes the iter-128 evaluate-then-extend-scalars LHS, contradicting the iter-130 LHS framing the same lemma statement (line 144) and its conclusion paragraph (line 163) now use.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: `lem:GrpObj_lieAlgebra_finrank`)
- **Lean target exists**: no — declaration not present. Expected: `\notready` (line 177), deferred to iter-130+ build per the directive (and the Lean docstring at lines 28–30 / 46–47 acknowledges the rank lemma lives elsewhere).
- **Signature matches**: N/A (Lean target intentionally absent).
- **Proof follows sketch**: N/A (Lean target intentionally absent).
- **`\notready` marker**: present (line 177). ✓
- **notes**: The proof has both a "primary route" (Steps 1–3, via the bridge to local-ring cotangent) and a "cross-check route" (Step 4, via the affine-chart Kähler rank) plus a dedicated "Iter-130 closure path under Replacement (B)" paragraph (line 203). The closure-path paragraph names the right Mathlib pieces but does not flag the `Classical.choice` opacity concern that the iter-130 prover lane raised. See "Red flags" below.

## Red flags

### Bridge lemma proof Step 1 still describes the iter-128 LHS framing
- `RigidityKbar.tex:151`: Step 1 of `lem:GrpObj_cotangent_bridge`'s proof reads "The iter-128 body of `lem:GrpObj_cotangentSpace` extends scalars of $(\Omega_{G/k})(G)$ along the ring map $\psi \colon \Gamma(G, \mathcal O_{G}) \to k$ induced by $\eta_G$ on global sections. Factor $\psi$ through the localisation at the identity stalk and the residue map …"
- The same lemma's statement (line 144) explicitly pins the LHS as "the iter-130+ chart-base-changed Kähler Lean body of `lem:GrpObj_cotangentSpace`", and the conclusion paragraph (line 163) refers to "the chart-base-changed Kähler module of Replacement (B) (depending on a chosen chart $V$ via `Classical.choice`)".
- **Inconsistency**: the proof sketch Step 1 starts from the iter-128 global-sections ring map $\psi : \Gamma(G, \mathcal O_G) \to k$, but the iter-130 body's ring map is the chart-restricted $\psi_V : \Gamma(G, V) \to k$ (different domain). The localisation-factoring narrative ($\Gamma(G, \mathcal O_G) \to \mathcal O_{G, \eta_G} \to k$) does not transfer mechanically to the chart form: from $\Gamma(G, V) \to k$ the prover would need to factor through the local stalk on the chart $\mathcal O_{V, \eta_G(\mathrm{pt})}$, then localise, then identify with $\mathcal O_{G, \eta_G}$ via the open-immersion stalk equivalence — none of which the current Step 1 mentions.
- **Severity**: **major**. The lemma is `\notready` and not blocking the current iter, so this is not critical, but a future bridge-prover lane would walk into a sketch that describes the wrong starting body.

### Rank lemma's iter-130 closure path does not flag `Classical.choice` opacity
- `RigidityKbar.tex:203`: the "Iter-130 closure path under Replacement (B)" paragraph reads "The body of `cotangentSpaceAtIdentity` (post-iter-130 body swap) is `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V)/Γ(Spec k, U)])` for a chart $V$ around $\eta_G(\mathrm{pt})$. The rank lemma closes by combining `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` … with `Module.finrank_baseChange` …"
- The actual Lean body (`GrpObj.lean:143` + `:169–170`) is `Classical.choice (α := ModuleCat k) ⟨(ModuleCat.extendScalars ψ_V.hom).obj …⟩`, not the bare base-change expression the prose names. `Classical.choice` is opaque to definitional unfolding, so a prover cannot just rewrite the body and apply `Module.finrank_baseChange`: they must reduce to "for every element of the witness set, the rank is `n`" via `Classical.choice_spec`, or thread the existential through the rank statement.
- The directive explicitly flagged this: "the prover did NOT attempt the rank lemma this iter due to the `Classical.choice` opacity concern; flag whether the blueprint's proof sketch is realistic against the iter-130 body."
- **Verdict**: the proof sketch is **not realistic** against the iter-130 body as currently written. A prover following only line 203 would attempt a direct `Module.finrank_baseChange` rewrite that fails because the body is `Classical.choice`-wrapped. The sketch needs an explicit "thread the existential through" step (e.g. recast the rank lemma's statement to assert the rank is `n` for every witness in the `smooth_locally_free_omega` existential, or — preferred — refactor `cotangentSpaceAtIdentity` to return the `Nonempty` witness as a named local constant so consumers can `Classical.choice_spec` it).
- **Severity**: **major**. The lemma is `\notready` and not blocking the current iter; but if dispatched to a prover lane in iter-131+ as-is, the sketch would mislead.

### Placeholder / suspect bodies
None. The Lean body of `cotangentSpaceAtIdentity` contains no `:= sorry`, no `:= True`, no `:= rfl` on a non-trivial claim. The `refine Classical.choice (α := ModuleCat k) ?_` step is structurally suspect-looking but is mathematically authorised by the blueprint's `Caveat on canonicity` paragraph (line 121) which explicitly names `Classical.choice` and explains why canonicity is not load-bearing for the live consumer (rigidity over $k$). The Lean docstring at lines 118–126 mirrors this caveat. So this is not a "suspect body" finding — the use of `Classical.choice` is sanctioned by the blueprint prose.

### Excuse-comments
None. The Lean inline comments (`GrpObj.lean:136–168`) are construction-step annotations that mirror the blueprint proof sketch, not "TODO replace with real def" / "wrong but works for now" excuses.

### Axioms / `Classical.choice` on non-trivial claims
- `GrpObj.lean:143`: `refine Classical.choice (α := ModuleCat k) ?_`. **Authorised by blueprint** (line 121's `Caveat on canonicity` paragraph, line 163's reference to "depending on a chosen chart $V$ via `Classical.choice`", and line 203's chart-existential framing). The downstream consequence — that any rank lemma must thread through the `Classical.choice`-wrapped body — is flagged above as a Red Flag against the rank lemma's proof sketch, not against the (i.a) definition.

## Unreferenced declarations (informational)

The Lean file contains exactly one substantive declaration (`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`), and it is referenced by `lem:GrpObj_cotangentSpace`. No unreferenced declarations. Coverage: 1/1.

## Blueprint adequacy for this file

- **Coverage**: 1/1 — the only Lean declaration in the file (`cotangentSpaceAtIdentity`) is referenced by `lem:GrpObj_cotangentSpace`.
- **Proof-sketch depth**: **adequate** for `lem:GrpObj_cotangentSpace` (the only block this file currently realises). The five-step body construction at line 115 is detailed enough that a prover could re-derive the iter-130 Lean body from prose alone (and indeed the prover lane did). The `Caveat on canonicity` paragraph (line 121) authorises the `Classical.choice` opacity. The deferred `\notready` lemmas (`lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`) have proof sketches that — see Red Flags — are misaligned with the iter-130 body and would need re-alignment before dispatch.
- **Hint precision**: **precise**. The `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` hint points at the correct declaration; the stub at lines 100–102 pins the exact signature including the relaxed `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder shape per the iter-129 fix-up.
- **Generality**: **matches need**. The blueprint's `{n : ℕ}`-parameterised stub is exactly what the project needs (an abelian variety of arbitrary relative dimension can instantiate the same declaration).
- **Recommended chapter-side actions**:
  - Re-align `lem:GrpObj_cotangent_bridge`'s proof Step 1 (line 151) to start from the iter-130 chart-base-changed body $k \otimes_{\Gamma(G, V)} \Omega[\Gamma(G, V) / \Gamma(\Spec k, U)]$ rather than the iter-128 global-sections $k \otimes_{\Gamma(G, \mathcal O_G)} \Omega[\ldots]$ form. The localisation-factoring narrative needs to go via the open-immersion stalk equivalence at the chart, not the global-sections-to-stalk localisation.
  - Add to `lem:GrpObj_lieAlgebra_finrank`'s "Iter-130 closure path" paragraph (line 203) an explicit acknowledgement that the body is `Classical.choice`-wrapped and that the rank closure must thread the existential through (e.g. via `Classical.choice_spec` on a re-shaped `Nonempty {M : ModuleCat k // …}` witness, or by refactoring `cotangentSpaceAtIdentity` to expose the chart-existential witness as a separate field for downstream `_spec`-style access). Without this acknowledgement, a prover lane reading only line 203 will attempt a `Module.finrank_baseChange` rewrite that fails because `Classical.choice` is opaque to unfolding.

## Severity summary

- **must-fix-this-iter**: 0.
- **major**: 2.
  1. `lem:GrpObj_cotangent_bridge` proof Step 1 (line 151) describes the iter-128 LHS framing while the lemma statement (line 144) and conclusion (line 163) pin the LHS to the iter-130 chart-base-changed body. Internal inconsistency in a `\notready` sketch.
  2. `lem:GrpObj_lieAlgebra_finrank` iter-130 closure-path paragraph (line 203) does not flag the `Classical.choice` opacity of the iter-130 body, leaving a prover lane that consumes the sketch with a misleadingly-direct closure plan.
- **minor**: 0.

**Overall verdict**: The (i.a) definition lemma `lem:GrpObj_cotangentSpace` is in good shape — its Lean realisation and blueprint prose are mutually faithful under the iter-130 Replacement (B) framing, with the `Classical.choice` opacity explicitly authorised on both sides — but the two downstream `\notready` lemmas (`lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`) carry iter-128-era proof-sketch residue that will need re-alignment before iter-131+ prover dispatch.
