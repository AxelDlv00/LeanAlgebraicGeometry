# Lean ↔ Blueprint Check Report

## Slug
grquot-iter050

## Iteration
050

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (chapter: `def:scheme_modules_glue`)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.glue` at line 100
- **Signature matches**: **partial** — the transition isomorphism form matches the blueprint exactly:
  `(Scheme.Modules.pullback (D.f i j)).obj (M i) ≅ (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)`
  corresponds to `f_{ij}^* M_i ≅ (t_{ij} ∘ f_{ji})^* M_j`. However, the blueprint explicitly requires
  the **module cocycle conditions** as hypotheses (self-transition `g_{ii} = id` and triple-overlap
  `g_{jk} ∘ g_{ij} = g_{ik}`) — these are entirely absent from the Lean signature. The `_g` prefix
  on the parameter signals it is currently unused/unstructured.
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold)
- **Notes**: The inline NOTE comment acknowledges: "the module-cocycle hypotheses on `g` are still
  to be filled; the multiplicative cocycle conditions remain to be added before the construction is
  closed." This is a documented gap, not a surprise, but it remains a signature deficiency relative
  to the blueprint.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (chapter: `def:gr_chart_quotient`)
- **Lean target exists**: yes — `chartQuotientMap` at line 64, axiom-clean
- **Signature matches**: yes — blueprint says "u^I : O_{U^I}^r → O_{U^I}^d by left multiplication by
  X^I"; Lean gives
  `SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin r) ⟶
   SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin d)`,
  which correctly models O^r → O^d on the chart U^I.
- **Proof follows sketch**: yes — `biproduct.matrix` with entries
  `scalarEnd ((Scheme.ΓSpecIso A).inv.hom ((universalMatrix d r I hI) p i'))` correctly implements
  left-multiplication by the universal matrix X^I; the blueprint's "matrix of components in the
  standard bases" is faithfully realised.
- **Notes**: The implementation uses `HasFiniteBiproducts.of_hasFiniteProducts` (per the memory
  note from iter-050 grquot-chartmap-biproduct-route) — consistent with the blueprint's mention that
  "Mathlib has no matrix ↦ morphism of free sheaves primitive."

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (chapter: `def:gr_universal_quotient_sheaf`)
- **Lean target exists**: yes — `universalQuotient` at line 118
- **Signature matches**: yes — `(d r : ℕ) : (scheme d r).Modules` correctly types the universal
  quotient sheaf U as a sheaf of O_{Gr(d,r)}-modules.
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold); NOTE comment documents dependency
  on `Scheme.Modules.glue`.
- **Notes**: Rides on the `glue` scaffold; will need the cocycle condition hypotheses once `glue`
  is completed.

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (chapter: `def:tautological_quotient`)
- **Lean target exists**: yes — `tautologicalQuotient` at line 126
- **Signature matches**: yes — blueprint says "u : O^r ↠ U" assembled from chart quotients; Lean
  gives `SheafOfModules.free (R := (scheme d r).ringCatSheaf) (Fin r) ⟶ universalQuotient d r`,
  which is exactly O^r → U on Gr(d,r).
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold)
- **Notes**: Rides on `universalQuotient` + `glue`.

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (chapter: `def:grassmannian_functor`)
- **Lean target exists**: yes — `functor` at line 138
- **Signature matches**: yes — `(d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type` is the correct Lean type for a
  contravariant functor from schemes to sets (the `.{0}` universe specialisation is a Lean
  technicality not visible in the blueprint prose).
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold)
- **Notes**: Blueprint specifies the Setoid-of-quotients construction (kernel equivalence); this
  detail is not yet in the Lean body.

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (chapter: `thm:grassmannian_universal_property`)
- **Lean target exists**: yes — `represents` at line 147
- **Signature matches**: yes — `(functor d r).RepresentableBy (scheme d r)` is the correct Lean
  encoding. The directive note confirms: `RepresentableBy` is data (a structure), not Prop, so
  `noncomputable def` is appropriate. The extra hypotheses `(hd : 1 ≤ d) (hdr : d ≤ r)` faithfully
  encode the blueprint's standing assumption "r ≥ d ≥ 1".
- **Proof follows sketch**: N/A — body is `:= sorry` (scaffold). The blueprint proof sketch is
  detailed (from-quotient-to-morphism, gluing, uniqueness) and would guide the implementation once
  prerequisites close.
- **Notes**: No `\leanok` on the proof block in the blueprint — correctly absent since the proof
  is not closed.

---

## Red flags

### Placeholder / suspect bodies
All five scaffold sorries (`glue`, `universalQuotient`, `tautologicalQuotient`, `functor`,
`represents`) have bodies `:= sorry`. The blueprint's `\leanok` markers are on the **statement
blocks** only (not the proof block of `represents`), which is correct per the AGENTS.md marker
vocabulary ("statement block: declaration is formalized — at least a sorry present"). No false
`\leanok` on proof blocks is present.

These sorry bodies are expected scaffolds. No excuse-comment or weakened-wrong definition is
present.

### Signature incompleteness — `Scheme.Modules.glue`
The `_g` parameter at line 102 captures only the transition isomorphisms `g_{ij}` but **none**
of the cocycle conditions the blueprint explicitly requires:
- `g_{ii} = id` (self-transition)
- `g_{jk} ∘ g_{ij} = g_{ik}` over triple overlaps (transported through the scheme-level cocycle)

These are stated in the blueprint's definition as the conditions "subject to which" the gluing
is performed. Without them in the signature, the `glue` API is unsound as currently sketched —
any future implementation could ignore the cocycle, producing a result that does not satisfy
the characterisation-up-to-unique-isomorphism the blueprint promises. This needs to be fixed
before the sorry is filled.

**Severity: major** (partial signature mismatch, fixable in-place; documented in the NOTE comment
but still blocks closing the scaffold correctly).

### Axioms / Classical.choice
No `axiom` declarations. No unauthorised `Classical.choice` patterns. `noncomputable` is used
appropriately for all declarations.

---

## Unreferenced declarations (informational)

Two declarations in the Lean file have no corresponding `\lean{...}` block in the blueprint:

| Declaration | Line | Role |
|---|---|---|
| `globalUnitSection` | 37 | Project-local helper: lifts a global section `a ∈ Γ(X,⊤)` to a section of the unit sheaf `SheafOfModules.unit`. Feeds `scalarEnd`. |
| `scalarEnd` | 50 | Project-local helper: builds scalar endomorphism `O_X → O_X` from a global section. Used as the matrix entries of `chartQuotientMap`. |

These are plumbing for `chartQuotientMap` that Mathlib does not provide. The blueprint's
definition of `chartQuotientMap` correctly flags "Mathlib has no 'matrix ↦ morphism of free
sheaves' primitive" but gives no indication that the approach is via `globalUnitSection` +
`scalarEnd`. A future prover attacking this file cold from the blueprint alone would not know
these helpers are needed or what their signatures are.

**Assessment**: major blueprint coverage gap (see Blueprint adequacy below).

---

## Blueprint adequacy for this file

- **Coverage**: 6/8 Lean declarations have a corresponding `\lean{...}` block.
  Unreferenced: 2 helpers (`globalUnitSection`, `scalarEnd`). These helpers are substantive
  (not trivial forwarding wrappers) and are load-bearing for the one axiom-clean declaration
  in the file (`chartQuotientMap`). A blueprint-writing subagent should add a short block for
  them.

- **Proof-sketch depth**: **adequate** for the five main declarations. The `represents` proof
  sketch (from-quotient-to-morphism, open-locus cover, gluing, uniqueness) is detailed enough
  to guide a prover. The `glue` construction sketch references the open-immersion pullback
  restriction equivalence and `existsUnique_gluing'` — sufficient guidance. The `functor` body
  (Setoid quotient + pullback functoriality) is described adequately.

  **Under-specified**: the `chartQuotientMap` block says "Mathlib has no matrix ↦ morphism
  primitive" but does not describe the scalar endomorphism route (`globalUnitSection` +
  `scalarEnd` + `biproduct.matrix`). A prover would need to discover this approach
  independently.

- **Hint precision**: **precise** — all six `\lean{...}` names exactly match the Lean
  declarations (fully qualified, correct namespaces).

- **Generality**: **matches need** — the types and universe levels in the Lean signatures are
  consistent with the blueprint's level of generality.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. Add a `\begin{lemma}...\end{lemma}` block (or an infrastructure remark block) for
     `globalUnitSection` and `scalarEnd` with `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}`
     and `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}`, explaining the scalar endomorphism
     route used to implement `chartQuotientMap`.
  2. Expand the `def:gr_chart_quotient` construction note to mention that the
     matrix-entries approach goes through scalar multiplication on `SheafOfModules.unit` via
     `biproduct.matrix`, to guide future implementation.
  3. Update the `def:scheme_modules_glue` signature description to include the cocycle
     conditions as explicit hypotheses (self-identity + triple-overlap), matching what the
     Lean signature will eventually need to carry.

---

## Severity summary

| Finding | Severity |
|---|---|
| `glue` signature missing cocycle condition hypotheses | **major** |
| `globalUnitSection` / `scalarEnd` have no blueprint blocks | **major** |
| Blueprint `chartQuotientMap` block does not describe the scalar endomorphism approach | **major** |

No **must-fix-this-iter** findings: no wrong signatures on axiom-clean declarations, no
excuse-comments, no weakened-wrong definitions, no axioms, no false `\leanok` on proof blocks.
All sorry bodies are correctly identified as scaffolds in the blueprint and in inline NOTE comments.

**Overall verdict**: `grquot-iter050` is structurally sound for a new-file iteration with explicit scaffolds — the three axiom-clean declarations (`globalUnitSection`, `scalarEnd`, `chartQuotientMap`) match the blueprint faithfully; the five scaffold signatures are correct except for the missing cocycle conditions on `glue`; two major blueprint coverage gaps need to be closed (helper blocks + `glue` cocycle spec) before the scaffold-filling work begins in earnest.
