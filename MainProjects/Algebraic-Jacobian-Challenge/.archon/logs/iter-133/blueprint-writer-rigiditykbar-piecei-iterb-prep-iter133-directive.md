# Blueprint Writer Directive

## Slug
rigiditykbar-piecei-iterb-prep-iter133

## Scope (single chapter only)

`blueprint/src/chapters/RigidityKbar.tex` — specifically:
1. **must-fix-this-iter**: harden `lem:GrpObj_mulRight_globalises` (lines 243–268) per `task_results/blueprint-reviewer-iter133.md` HARD GATE Q1 + mathlib-analogist verdict `task_results/mathlib-analogist-mulright-globalises-iter133.md`.
2. **bundled MED-B** (from `lean-vs-blueprint-checker-cotangent-grpobj-review132`): add a `\lean{...}` block for `cotangentSpaceAtIdentity_eq_extendScalars` (the iter-131 strong acceptance lemma, exists at `AlgebraicJacobian/Cotangent/GrpObj.lean:198`).
3. **bundled MED-C**: rewrite the second half of paragraph at lines 302–306 ("recommended downstream rewrite pattern") to describe the **direct `change`-based route** used in the iter-132 close at `AlgebraicJacobian/Cotangent/GrpObj.lean:276–282`, retaining the `obtain`+`rw [heq]` pattern only as an alternative.

Do NOT edit any other chapter file. Other blueprint-reviewer findings (`Jacobian.tex` C.2.a–C.2.e drift; `Cohomology_MayerVietoris.tex` broken refs) are explicitly out of scope this iter — deferred to iter-134+ soft-cleanup pass.

## Strategy context (the slice that matters)

The iter-127 over-k commitment binds: piece (i.b) MUST be functorial-shear-iso-based (not pointwise via `k̄`-points). Iter-132 closed piece (i.a) — the definition `cotangentSpaceAtIdentity` lands with the iter-131 `Classical.choose`-chain body (outer head symbol `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) ⁄ Γ(Spec k, U)])`), the companion structural-shape lemma `cotangentSpaceAtIdentity_eq_extendScalars` exposes the chart triple `(U, V, e, h_top)`, and the rank lemma `cotangentSpaceAtIdentity_finrank_eq` proves rank = n via `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`.

Piece (i.b) target: `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`. Per the iter-133 mathlib-analogist verdict (`analogies/mulright-globalises-cotangent.md`):

- **The Lean statement RHS should be sheaf-level**, using the abstract pullback presheaf `η_G^* (relativeDifferentialsPresheaf G.hom)` (or its sheaf-level analogue), **NOT** value-level chart-base-changed `cotangentSpaceAtIdentity G`. Rationale: decouples piece (i.b) from chart-localisation; pushes that identification (~100–200 LOC) into piece (i.c).
- **The shear iso construction `σ = lift (fst G G) μ : G ⊗ G ≅ G ⊗ G` in `Over (Spec k)`** is a NEEDS_MATHLIB_GAP_FILL (~30–60 LOC). Template: `CategoryTheory.GrpObj.mulRight` (`Mathlib.CategoryTheory.Monoidal.Grp_.lean:277-281`); inverse construction patterned on `GrpObj.isPullback` (Grp_.lean:293-323).
- **Base-change-of-differentials natural iso `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}`** is a NEEDS_MATHLIB_GAP_FILL (~150–300 LOC; load-bearing for piece (i.b)). Chains `TopCat.Presheaf.pullback` with the algebra-side `KaehlerDifferential.tensorKaehlerEquiv`.
- **Forbidden alternatives** (per iter-127 over-k risk register): do NOT model on `Mathlib.Geometry.Manifold.GroupLieAlgebra.mulInvariantVectorField` (requires `[Group G]`), `Mathlib.Topology.Algebra.Group.Basic.Homeomorph.shearMulRight` (requires `[Group G]`), or `pointEquivClosedPoint` / `IsAlgClosed K`-based idioms.

Total piece (i.b) LOC envelope under sheaf-level RHS recommendation: **210–440 LOC** over 2–4 iter; trigger (a') in STRATEGY.md does NOT fire.

## Required edits to `RigidityKbar.tex`

### Edit 1 (must-fix-this-iter): `lem:GrpObj_mulRight_globalises` hardening (lines 243–268)

Add the following content to harden the lemma for prover dispatch iter-134+:

(a) **Add a `% Lean signature stub:` comment block** before the `\begin{lemma}` (mirroring the style of `lem:GrpObj_cotangentSpace` at lines 96–102 and `lem:GrpObj_lieAlgebra_finrank` at lines 184–189). The signature stub should pin:
- The Lean target name: `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`.
- The signature: `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ⟨RHS iso shape⟩` — where the RHS iso shape is **sheaf-level**, of the form (suggested; the writer should choose the precise Mathlib type after a `lean_loogle` or `lean_leansearch` confirmation):
  ```
  Ω_{G.hom : G.left → Spec k} ≅ pr_1^* ((CategoryTheory.CommaMorphism.left η[G])^* Ω_{G.hom})
  ```
  in the appropriate Mathlib presheaf/sheaf-of-modules category. The writer must consult `lean_loogle` for the exact pullback-of-presheaves API the project's `relativeDifferentialsPresheaf` consumes (per `Differentials.lean`); pin a concrete Lean type rather than leaving the RHS prose-only.

(b) **Clarify the relationship between the named target `mulRight_globalises_cotangent` and the proof's actual construction `σ = ⟨pr₁, μ⟩`**. The blueprint-reviewer flagged this as item #2 of HARD GATE Q1: the prose talks about a shear iso `σ`, but the Lean target name talks about `mulRight`-globalisation. Two options for the writer to choose between:
  - (i) **Keep the target name** `mulRight_globalises_cotangent` and explain in the lemma's prose that the shear iso `σ = ⟨pr₁, μ⟩` realises the `mulRight`-translation action on the cotangent at fibre-bundle level (since `μ ∘ ⟨id, mulRight_a⟩ = ?` — the writer should pin the explicit Mathlib `GrpObj.mulRight` API used and how it composes with `pr_1`/`pr_2` to give the categorical shear). Cite `Mathlib.CategoryTheory.Monoidal.Grp_.lean:277-281` (`GrpObj.mulRight` API).
  - (ii) **Rename the target to align with the construction**, e.g. `shear_globalises_cotangent`. This is a cleaner exposition but requires the writer to confirm with the plan agent (via a "Notes for Plan Agent" section in the report) that the rename is desired — the plan agent will then push the new name into STRATEGY.md / PROGRESS.md.

The writer should default to option (i) (keep the name, add explanatory prose) unless the analogist's persistent file `analogies/mulright-globalises-cotangent.md` argues for option (ii). Either choice is defensible; the writer should pick one and stick with it.

(c) **Name the Mathlib lemma for the base-change-of-differentials identification** `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}`. Per the iter-133 mathlib-analogist (Decision 2), this is NEEDS_MATHLIB_GAP_FILL (~150–300 LOC). The chain Mathlib idiom is:
- Presheaf-side: `TopCat.Presheaf.pullback` API (consumed by the project's `relativeDifferentialsPresheaf`).
- Algebra-side: `KaehlerDifferential.tensorKaehlerEquiv` (for base change of Kähler differentials of algebras).
- The chain: pull the algebra-side equivalence through the presheaf-pullback construction.

The writer should:
- Add a paragraph naming this NEEDS_MATHLIB_GAP_FILL piece as a project-internal helper lemma (likely a new `\begin{lemma}` block, e.g. `lem:GrpObj_omega_basechange_proj` with `\notready`) inside the (i.b) sub-section, with proof sketch describing the chain.
- Cite the Mathlib lemmas (`TopCat.Presheaf.pullback`, `KaehlerDifferential.tensorKaehlerEquiv`) by name in the proof prose.

(d) **Optionally factor "restriction along the section `⟨id_G, η_G⟩`" into a sub-lemma**. The blueprint-reviewer flagged this as the third unstated load-bearing decision. The writer's call: either fold this into the main proof prose with more detail, or factor a `lem:GrpObj_omega_restrict_to_identity_section` sub-lemma. Default to the latter (sub-lemma) for prover ergonomics — easier to scaffold.

### Edit 2 (MED-B bundle): Add `\lean{cotangentSpaceAtIdentity_eq_extendScalars}` block

Add a small `\begin{lemma}` block after `lem:GrpObj_cotangentSpace` (around line 122 of the current chapter, before `lem:GrpObj_cotangent_bridge` at line 124) for the iter-131 strong acceptance lemma. Style: mirror `lem:GrpObj_cotangentSpace`. Suggested skeleton:

```latex
\begin{lemma}[Structural-shape rewrite handle for the cotangent space at the identity]
  \label{lem:GrpObj_cotangentSpace_extendScalars_witness}
  \lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}
  \uses{lem:GrpObj_cotangentSpace, thm:smooth_locally_free_omega}
  Under the hypotheses of \cref{lem:GrpObj_cotangentSpace}, there exist affine opens $U \subseteq \Spec k$, $V \subseteq G.\mathrm{left}$, an inclusion $e : V \leq G.\mathrm{hom}^{-1}\,U$, and a top-inclusion $h_{\mathrm{top}} : \top \leq \eta_G^{-1}\,V$ such that under the $\Gamma(\Spec k, U)$-algebra structure on $\Gamma(G, V)$ from \texttt{appLE}, the cotangent space at the identity equals the explicit chart-base-changed Kähler module:
  \[
    \mathrm{cotangentSpaceAtIdentity}\,G \;=\; (\mathrm{extendScalars}\,\psi_V.\mathrm{hom}).\mathrm{obj}\bigl(\mathrm{ModuleCat.of}\,\Gamma(G, V)\,\Omega[\Gamma(G, V)/\Gamma(\Spec k, U)]\bigr).
  \]
\end{lemma}

\begin{proof}
  \uses{lem:GrpObj_cotangentSpace, thm:smooth_locally_free_omega}
  Reproduce the body's \texttt{Classical.choose}-chain on \cref{thm:smooth_locally_free_omega}'s existential — the same chart triple $(U, V, e)$ and same $h_{xV} : x_0 \in V$ extraction. The top-inclusion $h_{\mathrm{top}} : \top \leq \eta_G^{-1}\,V$ follows from $h_{xV}$ via $\mathrm{Subsingleton.elim}$ on points of $\Spec k$. The equation closes by $\mathrm{rfl}$ once the right-hand-side $\mathrm{Classical.choose}$-chain definitionally matches the body's.
\end{proof}
```

(The actual Lean signature exists at `AlgebraicJacobian/Cotangent/GrpObj.lean:198–219`. The blueprint statement should match the Lean signature.)

Place this **between** `lem:GrpObj_cotangentSpace` and `lem:GrpObj_cotangent_bridge`. Once placed, update the three by-name references to this lemma in the chapter (`\texttt{cotangentSpaceAtIdentity\_eq\_extendScalars}` at lines 121, 206, 307) to use `\cref{lem:GrpObj_cotangentSpace_extendScalars_witness}` (where appropriate; you may keep some of the `\texttt{...}` references that contextually make sense as Lean-name mentions, but at least one of the three should become a `\cref{...}`).

### Edit 3 (MED-C bundle): Update the recommended downstream rewrite pattern (lines 302–306)

The current paragraph at lines 302–306 describes the recommended downstream rewrite pattern as:
> obtain ⟨U, V, e, h_top, heq⟩ := cotangentSpaceAtIdentity_eq_extendScalars G; then rewrite with heq to expose the explicit extendScalars form; feed chart-side hfree/hrank into Module.finrank_baseChange.

The **iter-132 actual closure** at `AlgebraicJacobian/Cotangent/GrpObj.lean:276–282` uses a different route: a direct `change Module.finrank k (TensorProduct Γ(G, V) k Ω[…]) = n` step that exposes the body's underlying `TensorProduct` carrier via `ModuleCat.ExtendScalars.obj'`'s definitional unfolding, then `rw [Module.finrank_baseChange]` + `exact Module.finrank_eq_of_rank_eq hrank`. No `obtain` + `rw [heq]` is used.

Rewrite the paragraph to describe **both routes**, with the direct `change`-based route as the primary recommendation (since that's what the iter-132 lemma actually uses), and the `obtain` + `rw [heq]` route as an alternative consuming `lem:GrpObj_cotangentSpace_extendScalars_witness` (Edit 2). The new paragraph should explicitly note that:
- The two routes are mathematically equivalent (the body's carrier and the `extendScalars`-of-`ModuleCat.of` form share the same `Classical.choose` extraction, hence are definitionally equal).
- The direct `change` route is shorter and what `cotangentSpaceAtIdentity_finrank_eq`'s body at `Cotangent/GrpObj.lean:276–282` actually does.
- The `obtain` + `rw [heq]` route is preserved as an alternative for downstream consumers that prefer to make the rewrite step explicit.

## Out of scope (do NOT edit)

- `Jacobian.tex` (C.2.a–C.2.e prose drift): deferred iter-134+ soft cleanup; not in your write-domain this iter.
- `Cohomology_MayerVietoris.tex` (broken `\ref{...}` cross-refs): roll into future blueprint-cleanup pass; not in your write-domain this iter.
- `lem:GrpObj_omega_free` and `lem:GrpObj_omega_rank_eq_dim` (piece (i.c) lemmas): not on iter-133 critical path; flag for iter-137+ pre-prover hardening; do NOT add Lean signature stubs this iter.
- `lem:GrpObj_cotangent_bridge` (piece (i.a) bridge, `\notready`): vestigial-on-live-path under (B); the iter-131 trio→duo collapse demotes it. Do not modify.
- `Cotangent/GrpObj.lean` or any other `.lean` file (writer is read-only on Lean).

## Verification

After your edits, the chapter should:
- Have `lem:GrpObj_mulRight_globalises` with a Lean signature stub + clear `mulRight`-vs-`σ` relationship + named base-change-of-differentials Mathlib chain + (optional) sub-lemma for section-restriction.
- Have a new `\begin{lemma}` block for `cotangentSpaceAtIdentity_eq_extendScalars` at the right place in piece (i.a).
- Have the rewrite-pattern paragraph (former lines 302–306) re-cast to describe the direct `change` route as primary.
- Compile in `leanblueprint` if invoked (no broken `\uses{...}` introduced, no unbalanced LaTeX).
- No `\leanok` / `\notready` marker tampering: `lem:GrpObj_mulRight_globalises` stays `\notready`; new `lem:GrpObj_cotangentSpace_extendScalars_witness` gets `\leanok` (the Lean proof is closed at `Cotangent/GrpObj.lean:198`).

Report to `task_results/blueprint-writer-rigiditykbar-piecei-iterb-prep-iter133.md` per `.archon/subagents/blueprint-writer.md` rules.

## Read-only inputs (the writer should read)

- The current `blueprint/src/chapters/RigidityKbar.tex` (the chapter being edited).
- `task_results/mathlib-analogist-mulright-globalises-iter133.md` (this iter's analogist verdict).
- `analogies/mulright-globalises-cotangent.md` (persistent design file).
- `analogies/cotangent-body-shape.md` (iter-131's analogist on the body shape; supplies context on the chart-base-change body and its composition properties).
- `AlgebraicJacobian/Cotangent/GrpObj.lean` (lines 149–282; the implemented piece (i.a) — for verifying the lemma statements against the actual Lean signatures).
- `AlgebraicJacobian/Differentials.lean` (`relativeDifferentialsPresheaf` definition + `smooth_locally_free_omega`).
- `task_results/blueprint-reviewer-iter133.md` (this iter's blueprint-reviewer report — particularly the HARD GATE Q1 + Q2 sections).
