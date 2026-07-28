Narrow adversarial review. Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge. Load the horizon skill at $ARCHON_HORIZON_SKILL if you need workspace conventions, but keep this focused — I need a verdict, not a survey.

Review these four NEW files (all mine, this session):
  AlgebraicJacobian/Albanese/SymPowInterface.lean
  AlgebraicJacobian/Albanese/AlbaneseFromData.lean
  AlgebraicJacobian/Albanese/AVSelfProduct.lean
  AlgebraicJacobian/Albanese/AlbaneseJacobian.lean

CONTEXT. `Pic0.SymmetricPower` in Albanese/AlbaneseUP.lean is a `sorry`-BODIED definition, and six pinned obligations are stated against it. I argued those are undischargeable (equations between morphisms out of a junk term) and instead defined `SymPowData C n` — the symmetric power's universal property as a STRUCTURE — and proved Milne's Proposition III.6.1 over it.

THE ONE QUESTION THAT MATTERS: is this real content, or have I dressed up a `sorry` as an interface?

Attack it on these specific fronts, with your own commands:

(A) VACUITY / TRIVIALITY. Read `SymPowData` in SymPowInterface.lean. Is `symPowDataOne` (the n=1 inhabitant) genuine — does it really construct a `SymPowData C 1`, and is the `desc` field's universal property actually verified rather than sidestepped? Separately: is `SymPowData` so STRONG that my downstream theorems become trivial (e.g. does `desc` already hand over the conclusion)?

(B) IS THE HEADLINE NEAR-TAUTOLOGICAL? `exists_unique_albanese_factorisation` (AlbaneseFromData.lean §1) takes `hdesc : ∃! ψ, D.symAVMap φ = f ≫ ψ` and concludes `∃! ψ, φ = aj ≫ ψ`. Both are "∃! ψ" statements. Is the theorem doing real work, or is it transporting an ∃! across something that makes it a restatement? I believe the content is the CONNECTOR (`albaneseFactorisation_iff`), whose forward direction genuinely uses that ψ is a monoid-object homomorphism via `map_prod (IsMonHom.monoidHom ψ _)`. Verify that the homomorphy is load-bearing: would the forward direction go through WITHOUT `[IsMonHom ψ]`? If it would, my claim about Milne's step 5 is wrong.

(C) UNUSED HYPOTHESES. Run `mcp__lean-lsp__lean_minimal_hypotheses` on:
    AlgebraicGeometry.exists_unique_albanese_factorisation_of_birational
    CategoryTheory.exists_unique_albanese_factorisation
    CategoryTheory.albaneseFactorisation_iff
I did NOT run this. Any hypothesis reported as unused is a real finding — it would mean I am carrying a binder that suggests more content than exists (e.g. if `hproj`, `hsr`, or `hVpre` turn out unused).

(D) THE AXIOM ATTRIBUTION. I claim the `sorryAx` in `Pic0.albanese_universal_property_of_symPowData` is ENTIRELY the Picard seam, evidenced by `albanese_universal_property_of_symPowData_generic` being axiom-clean. Verify both `#print axioms` results, AND check I did not weaken a hypothesis in the generic version to buy cleanliness — compare the two binder lists.

(E) OVERSTATEMENT. Do the docstrings and the module headers claim more than is proved? I explicitly disclaim a closed Jacobian result — check I did so consistently, and flag any sentence a reader would take as stronger than the machine supports.

Report a clear verdict on (A)–(E), most severe first, with the exact commands you ran. If the central claim is overstated, say so plainly.
