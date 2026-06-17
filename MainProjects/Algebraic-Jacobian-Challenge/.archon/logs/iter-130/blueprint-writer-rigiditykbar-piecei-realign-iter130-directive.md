# Blueprint Writer Directive

## Slug
rigiditykbar-piecei-realign-iter130

## Iter
130

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context (concise)

Iter-130 dispatches a prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean` to **swap the body of `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`** from the iter-128 evaluate-then-extend-scalars-at-`op ⊤` form (which the iter-129 mathlib-analogist proved computes the zero `k`-module for every smooth proper geometrically irreducible `G/k` with relative dim `n ≥ 1`) to **Replacement (B): affine-chart base change** via the already-shipped `smooth_locally_free_omega` (Differentials.lean) + `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`.

The full Replacement (B) construction is documented in `analogies/lieAlgebra-rank-bridge.md` § Recommendation (lines 124–166 of that file). Lean body sketch:

```lean
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ModuleCat k := by
  classical
  obtain ⟨U, V, e, hxV, _hU, _hV, _hfree, _hrank⟩ :=
    smooth_locally_free_omega (n := n) G.hom (η_G_image_pt G)
  letI : Algebra Γ(Spec (.of k), U) Γ(G.left, V) :=
    (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
  let ψV : Γ(G.left, V) ⟶ CommRingCat.of k := <small adjunction calculation>
  exact (ModuleCat.extendScalars ψV.hom).obj
    (ModuleCat.of Γ(G.left, V) (Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)]))
```

The iter-129 RigidityKbar.tex Piece (i) writer pass authored prose that frames the iter-128 evaluate-then-extend-scalars body as the **canonical realisation** of `η_G^* Ω_{G/k}` and the bridge lemma `lem:GrpObj_cotangent_bridge` as a **tautological identification** between the iter-128 body and the stalk-side `𝔪_{η_G}/𝔪_{η_G}^2`. Per the iter-130 blueprint-reviewer + iter-129 lean-vs-blueprint-checker, this framing is no longer accurate: under Replacement (B), the body is a chart-base-changed Kähler module (non-canonical, dependent on a `Classical.choice` chart), and the bridge to stalk-side cotangent becomes a ~300–600 LOC follow-up (not tautological).

## Required changes (the only edits to make this iter)

### Change 1: rewrite `lem:GrpObj_cotangentSpace` proof body (lines 112–120)

Replace the iter-129 proof prose:
> "The iter-128 Lean construction realises $\eta_G^* \Omega_{G/k}$ as the extension of scalars to $k$, along the ring map $\psi \colon \Gamma(G, \mathcal O_G) \to k$ induced by $\eta_G$ on global sections, of the global-sections module of the relative cotangent presheaf [...] Equivalently — and this is the content of the bridge lemma \cref{lem:GrpObj_cotangent_bridge} below — this $k$-module is canonically isomorphic to the cotangent space $\mathfrak m_{\eta_G} / \mathfrak m_{\eta_G}^2$ [...] Combining with the bridge lemma yields the finitely-generated-free claim [...]"

with a Replacement-(B)-aligned proof prose:

> "The iter-130 Lean construction realises $\mathfrak g^\vee = \eta_G^* \Omega_{G/k}$ as a chart-base-changed Kähler module: by the forward Jacobian criterion \cref{thm:smooth_locally_free_omega} (already in the tree as `AlgebraicGeometry.Scheme.smooth_locally_free_omega`), there exists an affine chart $V \subseteq G$ around the image of the identity section $\eta_G(\mathrm{pt})$, with affine base chart $U \subseteq \Spec k$ and the structural ring map $\Gamma(\Spec k, U) \to \Gamma(G, V)$ exhibiting `Algebra.IsStandardSmoothOfRelativeDimension n` (and consequently $\Omega_{\Gamma(G,V) \,/\, \Gamma(\Spec k, U)}$ is a free $\Gamma(G,V)$-module of rank $n$ by `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`). The cotangent space at the identity is then defined as the base change to $k$ of this algebraic Kähler module along the ring map $\psi_V \colon \Gamma(G, V) \to k$ obtained by restricting the identity section $\eta_G$ to $V$ and composing with the canonical iso $\Gamma(\Spec k, \cdot) \cong k$:
> $$
>   \mathfrak g^\vee \;\;:=\;\; k \,\otimes_{\Gamma(G,V)}\, \Omega_{\Gamma(G,V) \,/\, \Gamma(\Spec k, U)}.
> $$
> This is a finitely generated free $k$-module of rank $n$ by base-change of a free module along $\psi_V$ (the rank is preserved; see \cref{lem:GrpObj_lieAlgebra_finrank}).
>
> *Caveat on canonicity.* The construction depends on a chart choice $V$ extracted via `Classical.choice` from the existential statement of `smooth_locally_free_omega`; it is therefore not canonically attached to $G$ in the strictest sense. For the live consumer (rigidity over $k$, via \cref{thm:rigidity_over_kbar}), the existence of a rank-$n$ free $k$-module is the only structural content needed, so canonicity is not load-bearing. A canonical (chart-independent) presentation via the stalk-side cotangent $\mathfrak m_{\eta_G}/\mathfrak m_{\eta_G}^2$ is available as a future bridge (\cref{lem:GrpObj_cotangent_bridge} below, currently `\notready`) at additional cost; the project defers that bridge until a non-rigidity consumer materialises that requires canonicity."

Keep the lemma's **statement** (lines 92–110) unchanged: the finitely-generated-free claim and the encoding note on un-dualisation are correct. Only the proof prose needs the Replacement-(B) re-alignment.

### Change 2: hedge `lem:GrpObj_cotangent_bridge` and add `\notready` (lines 122–161)

Two specific edits:

- **Mark with `\notready`**: add `\notready` near the top of the lemma block (parallel to `lem:GrpObj_lieAlgebra_finrank`'s `\notready` on line 174). The Lean target `cotangentSpaceAtIdentity_iso_localRingCotangent` does not exist in the tree.
- **Hedge the LHS framing**: in the lemma's *statement* (currently line 141 says "the left-hand side is the iter-128 evaluate-then-extend-scalars Lean body of \cref{lem:GrpObj_cotangentSpace}"), replace "iter-128 evaluate-then-extend-scalars Lean body" with "iter-130+ chart-base-changed Kähler Lean body" (matching the new Change-1 prose).
- **Drop the "tautological" framing** in the proof body (currently line 160 says "the bridge is a tautological identification of two constructions of the same $k$-module, valid for any group scheme with an identity section in $\Over\,(\Spec k)$"). Replace with:
  > "The bridge identifies the chart-base-changed Kähler module of Replacement (B) (depending on a chosen chart $V$ via `Classical.choice`) with the canonical stalk-side cotangent $\mathfrak m_{\eta_G} / \mathfrak m_{\eta_G}^2$. The two are abstractly isomorphic as $k$-modules — both have rank $n$ and arise as cotangent spaces at the identity — but the isomorphism is non-trivial to construct: it is a localisation-along-the-identity-stalk step (Step 1 below) composed with the standard $k \otimes_R \Omega_{R/k} \cong \mathfrak m/\mathfrak m^2$ identification (Step 2 below). The cost of this bridge is estimated at 300–600 LOC and is deferred until a non-rigidity consumer requires canonicity (e.g. a future Lie-algebra-bracket consumer of $\mathfrak g$)."

Keep Steps 1 + 2 of the proof as written (they are the correct chain for the bridge); only the framing sentence needs revision.

### Change 3: do NOT touch the (i.b)/(i.c) trio

The lemmas `lem:GrpObj_mulRight_globalises` (lines 201–226), `lem:GrpObj_omega_free` (lines 228–239), and `lem:GrpObj_omega_rank_eq_dim` (lines 241–252) are already Replacement-(B)-compatible: they consume only the existence of the rank-$n$ free $k$-module $\mathfrak g^\vee$, not its specific body shape. Do not modify their statements or proofs.

### Change 4: do NOT touch the rank lemma `lem:GrpObj_lieAlgebra_finrank` (lines 163–199)

The rank-equals-$n$ claim is the iter-130+ closure target under Replacement (B); per `analogies/lieAlgebra-rank-bridge.md` Decision 3, the closure chain is `smooth_locally_free_omega` + `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` + `Module.finrank_baseChange` [verified iter-130] + `Algebra.TensorProduct.instFree` [verified iter-130 — covers the `Module.Free.tensorProduct` requirement]. The lemma statement is correct; do not modify it.

You may add a brief line at the end of the existing proof sketch (after the current Step 4 cross-check, line 198) noting the verified iter-130 closure path under Replacement (B):
> "*Iter-130 closure path under Replacement (B)*: the body of `cotangentSpaceAtIdentity` (post-iter-130 body swap) is `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V)/Γ(Spec k, U)])` for a chart $V$ around $\eta_G(\mathrm{pt})$. The rank lemma closes by combining `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (Step 1 above; gives rank $n$ over $\Gamma(G, V)$) with `Module.finrank_baseChange` (gives `Module.finrank k (TensorProduct Γ(G, V) k Ω[...]) = Module.finrank Γ(G, V) Ω[...] = n`). All four Mathlib names verified iter-130."

## Out of scope (do NOT modify this iter)

- Other chapters (Jacobian.tex, AbelJacobi.tex, etc.).
- The variable name `kbar` → `k` rename in `RigidityKbar.tex` § Statement (line 14 paragraph). This is a deferred editorial cleanup; do not touch.
- The pile-cost numbers / honest-LOC accounting at the end of the Piece (i) subsection (lines 260–262). These are tied to STRATEGY.md and the plan agent will revise them separately.

## Required reading before drafting

- `analogies/lieAlgebra-rank-bridge.md` (full file; the Recommendation section at lines 124–166 and the closure chain at lines 100–122 are load-bearing).
- The current `blueprint/src/chapters/RigidityKbar.tex` (focus § Piece (i) subsection, lines 81–262).
- The Lean target `AlgebraicJacobian/Cotangent/GrpObj.lean` (single file; informational — your edits do NOT touch this file).
- `AlgebraicJacobian/Differentials.lean` lines 124–143 (the forward Jacobian criterion `smooth_locally_free_omega` that Replacement (B) consumes; informational).

## Out-of-scope-but-flag

If you notice cross-chapter inconsistencies (e.g. `Jacobian.tex` still using `kbar` somewhere), do NOT fix them — record them under "Notes for plan agent" in your report.

## Mathlib names verified by plan agent this iter

These can be cited in the chapter prose without uncertainty markers:
- `Module.finrank_baseChange` (`Mathlib.LinearAlgebra.Dimension.Constructions`)
- `Algebra.TensorProduct.instFree` (`Mathlib.RingTheory.TensorProduct.Free`)
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`)
- `Algebra.IsStandardSmooth.free_kaehlerDifferential` (verified iter-129)
- `Ideal.IsLocalRing.CotangentSpace` (verified iter-129)
