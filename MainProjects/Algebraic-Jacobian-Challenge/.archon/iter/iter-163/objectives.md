# Iter-163 objectives (detail)

## Prover lane (1 file, DEEP)

### `AlgebraicJacobian/AbelianVarietyRigidity.lean` — Milne §I.3 additivity corollaries
Scaffold + prove, building on the proven `rigidity_lemma` (sig: `X Y Z : Over (Spec kbar)`,
`[IsProper X.hom] [GeometricallyIrreducible (X⊗Y).hom] [LocallyOfFiniteType (X⊗Y).hom]
[IsReduced (X⊗Y).left] [IsSeparated Z.hom]`, `f : X⊗Y ⟶ Z`, collapse hyp
`lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀` ⟹ `∃ g : Y ⟶ Z, f = snd X Y ≫ g`):

- **(A)** `hom_additive_decomp_of_rigidity` (Milne Cor 1.5) — blueprint `lem:hom_additivity_over_product`.
  The GrpObj-hom-group difference `φ` collapses the V-axis ⟹ `rigidity_lemma` ⟹ `φ = snd ≫ g'`;
  `φ` vanishes on the `{v₀}×W` section ⟹ `g'` constant ⟹ `φ ≡ η[A]` ⟹ `h = (f∘p)·(g∘q)`. The `·`
  is the `GrpObj`-induced op on `Hom(V⊗W,A)` (`⟨u,v⟩ ≫ mul`); NO commutativity needed.
- **(B)** `av_regularMap_isHom_of_zero` (Milne Cor 1.2) — blueprint `lem:av_regular_map_is_hom`.
  From (A) with `h := mul_A ≫ α`, V=W=A.

DEEP lane, PARTIAL acceptable. Prefer (A) axiom-clean over rushing both. Any residual = named
top-level decl (no buried sorry). Do not touch the proven chain, the 3 deferred scaffolds, or
protected signatures.

## Blueprint state
- `AbelianVarietyRigidity.tex`: HARD GATE cleared (blueprint-reviewer `avr-fastpath`,
  complete+correct). New "Milne §I.3 chain" section holds the targets.
- `Jacobian.tex`: cube narrative purged (writer `jacobian-cube-purge`); consistent with Route C.

## Deferred (not this iter)
Thm 3.2 surface extension (`rational_map_to_av_extends`, riskiest gap), `morphism_Ga_to_av_const`
(Prop 3.9), the 3 genus-0 scaffolds, the RR bridge, Route A.
