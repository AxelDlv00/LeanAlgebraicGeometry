/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.FGAPicRepresentability
import AlgebraicJacobian.Genus

/-!
# The identity component of the Picard scheme (A.3)

This file is the **A.3** sub-build chapter for the project's positive-genus arm
of `nonempty_jacobianWitness`. It scaffolds the abstract identity-component
substrate for a `k`-group scheme locally of finite type and specialises it to
`G = Pic_{C/k}`, packaging:

1. the open-and-closed subgroup-scheme structure of the identity component,
2. the degree map `Pic_{C/k}(k) → ℤ`,
3. the abelian-variety identification of `Pic⁰_{C/k}` (the Jacobian variety
   of `C` when `C/k` is a smooth proper geometrically integral curve of
   positive genus).

## Status (iter-185 NEW file-skeleton)

This file is the **iter-185 IdentityComponent** file-skeleton (NEW lane,
blueprint-reviewer HARD GATE cleared for the iter-184 plan-phase chapter
`Picard_IdentityComponent.tex`). Each of the five blueprint-pinned
declarations carries the *intended* substantive type signature (matching the
`\lean{...}` pin in `Picard_IdentityComponent.tex`) with a `sorry` body. The
bodies are iter-186+ work; iter-185's mandate is the mechanical scaffold only.

The 5 pinned declarations are:

1. `AlgebraicGeometry.GroupScheme.IdentityComponent` (def, ~5 LOC) — the
   **identity component** `G^0` of a `k`-group scheme `G` locally of finite
   type, as a `k`-scheme (an `Over (Spec k)`-object). Abstract substrate
   reusable outside the Picard context; not yet in Mathlib.
2. `AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme`
   (theorem, ~10 LOC) — the bundled statement that `G^0` is an open and
   closed subscheme of `G` via an open immersion `G^0 ↪ G`.
3. `AlgebraicGeometry.Scheme.Pic0Scheme` (def, ~5 LOC) — the **identity
   component of the Picard scheme** `Pic⁰_{C/k}`, obtained by applying
   `IdentityComponent` to `G = PicScheme C`.
4. `AlgebraicGeometry.Scheme.PicScheme.degree` (def, ~5 LOC) — the **degree
   map** `Pic_{C/k}(k) → ℤ`, extracting the leading coefficient of the
   Hilbert polynomial of a representing invertible sheaf relative to a fixed
   degree-one polarisation `O_C(1)`.
5. `AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety` (theorem, ~10 LOC)
   — the **abelian-variety identification** of `Pic⁰_{C/k}`: smooth, proper,
   geometrically irreducible `k`-group scheme of dimension `g(C)` --- the
   Jacobian variety of `C`.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof", each
pinned declaration carries a substantive, non-tautological type:

- `IdentityComponent G : Over (Spec (.of k))` — a `k`-scheme, not the
  tautological `G` itself.
- `IdentityComponent.isOpenSubgroupScheme G` — asserts the *existence* of an
  open immersion morphism `IdentityComponent G ⟶ G` whose underlying map of
  schemes is both an open and a closed immersion (clopen subscheme).
- `Pic0Scheme C : Over (Spec (.of k))` — a `k`-scheme.
- `PicScheme.degree C : (Spec (.of k) ⟶ (PicScheme C).left) → ℤ` —
  a genuine function from `k`-points to `ℤ`, not a constant.
- `Pic0Scheme.isAbelianVariety C` — asserts the conjunction of the four
  abelian-variety properties (proper, smooth, geometrically irreducible,
  group-object structure); not vacuous because each conjunct is a genuine
  property/structure on the (typed-sorry) `Pic0Scheme C`.

## References

Blueprint: `blueprint/src/chapters/Picard_IdentityComponent.tex` (560 LOC,
5 pins). Sources:
- Kleiman, "The Picard scheme", §5, Lem.~`lem:agps` (identity component
  substrate) + Prp.~`prp:pic0` (specialisation to `Pic_{C/k}`) +
  Thm.~`th:qpp&p` (quasi-projectivity/projectivity) + Cor.~`cor:sm`
  (smoothness/dimension) + Ex.~`ex:jac` + Rmk.~`rmk:Jac`
  (arXiv:math/0504020 pp. 36, 38, 47, 50–51);
- Milne, "Abelian Varieties" (course notes, 2008), §III.1
  (def. of abelian variety, p. 8; dimension equals genus, Rmk. III.1.4(e),
  p. 86).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## §1. The identity component of a group scheme — abstract substrate

The identity component is an abstract feature of `k`-group schemes locally of
finite type. We package the definition + open-and-closed-subgroup-scheme
structure in the `GroupScheme` namespace so they are reusable outside the
Picard context.

In this project, a "`k`-group scheme" is encoded as an
`Over (Spec (.of k))`-object `G` carrying a `[GrpObj G]` instance (the
group-object structure in the over-category). The locally-of-finite-type
hypothesis is the `[LocallyOfFiniteType G.hom]` instance on the structural
morphism to the base.

Blueprint references: `def:identity_component_group_scheme` +
`thm:identity_component_open_subgroup` (Kleiman §5 Lem.~`lem:agps`). -/

namespace GroupScheme

/-- Helper (iter-188): in a **Noetherian** topological space `α`, the set of
connected components is finite.

Proof: the map `irreducibleComponents α → ConnectedComponents α` sending each
irreducible component `C` to the connected component of an arbitrary chosen
point of `C` is well-defined (because `C` is preconnected, hence contained in
a single connected component) and surjective (because every point lies in
some irreducible component, namely `irreducibleComponent x`, which is a
subset of `connectedComponent x`). The source is finite by
`TopologicalSpace.NoetherianSpace.finite_irreducibleComponents`, so the
target is finite by `Finite.of_surjective`. -/
private lemma noetherianSpace_finite_connectedComponents
    {α : Type*} [TopologicalSpace α] [TopologicalSpace.NoetherianSpace α] :
    Finite (ConnectedComponents α) := by
  classical
  have hfin : (irreducibleComponents α).Finite :=
    TopologicalSpace.NoetherianSpace.finite_irreducibleComponents
  haveI : Finite ↥(irreducibleComponents α) := hfin.to_subtype
  refine Finite.of_surjective
    (fun C : ↥(irreducibleComponents α) =>
      (ConnectedComponents.mk : α → ConnectedComponents α)
        ((C.property : Maximal IsIrreducible C.val).prop.nonempty.some)) ?_
  intro c
  obtain ⟨x, rfl⟩ := ConnectedComponents.surjective_coe c
  refine ⟨⟨irreducibleComponent x, irreducibleComponent_mem_irreducibleComponents x⟩, ?_⟩
  rw [ConnectedComponents.coe_eq_coe]
  refine (connectedComponent_eq ?_).symm
  exact irreducibleComponent_subset_connectedComponent
    (isIrreducible_irreducibleComponent (x := x)).nonempty.some_mem

/-- Helper (iter-188): in a **Noetherian** topological space `α`, each
connected component is open.

Proof: `ConnectedComponents α` is totally disconnected
(`ConnectedComponents.totallyDisconnectedSpace`), hence T1
(`TotallyDisconnectedSpace.t1Space`), and finite by
`noetherianSpace_finite_connectedComponents`. A finite T1 space is discrete
(`Finite.instDiscreteTopology`), so the singleton
`{ConnectedComponents.mk x}` is open in the quotient. The preimage of this
singleton under the continuous quotient map `ConnectedComponents.mk` is
`connectedComponent x` (`connectedComponents_preimage_singleton`), which is
therefore open. -/
private lemma noetherianSpace_isOpen_connectedComponent
    {α : Type*} [TopologicalSpace α] [TopologicalSpace.NoetherianSpace α]
    (x : α) :
    IsOpen (connectedComponent x) := by
  haveI : Finite (ConnectedComponents α) := noetherianSpace_finite_connectedComponents
  haveI : DiscreteTopology (ConnectedComponents α) := inferInstance
  have h := (isOpen_discrete
    ({(ConnectedComponents.mk x : ConnectedComponents α)} : Set _)).preimage
    ConnectedComponents.continuous_coe
  rwa [connectedComponents_preimage_singleton] at h

/-- Helper (iter-188): the **`LocallyConnectedSpace` instance** for the
underlying topological space of a `k`-scheme `G.left` whose structural
morphism `G.hom : G.left ⟶ Spec k` is locally of finite type.

The substantive content is EGA I 6.1.9: a locally Noetherian topological
space has open connected components — equivalently, is locally connected.
Pushed through the chain: `Spec k` is Noetherian (a field has Noetherian
spectrum); `LocallyOfFiniteType G.hom + IsLocallyNoetherian (Spec k) ⟹
IsLocallyNoetherian G.left` (Mathlib's
`AlgebraicGeometry.LocallyOfFiniteType.isLocallyNoetherian`); and the
implication `IsLocallyNoetherian X ⟹ LocallyConnectedSpace X.toTopCat`
is the iter-188 project-side helper (`noetherianSpace_finite_connectedComponents`
+ `noetherianSpace_isOpen_connectedComponent`).

The classical proof: each point `y ∈ G.left` has an open affine
neighbourhood `W = Spec R` with `R` Noetherian, hence `|W|` is a Noetherian
topological space; in a Noetherian space, each `connectedComponent y` is
clopen (finite irreducible components ⟹ finite connected components ⟹
finite T1 quotient ⟹ discrete quotient ⟹ singletons clopen in quotient ⟹
preimages clopen). Pulled back along the open inclusion `W ↪ G.left`,
this gives an open connected neighbourhood of `y` inside any open `F`
containing `y`. -/
private instance identityComponent_locallyConnectedSpace
    {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [LocallyOfFiniteType G.hom] :
    LocallyConnectedSpace G.left := by
  haveI : IsLocallyNoetherian G.left := LocallyOfFiniteType.isLocallyNoetherian G.hom
  rw [locallyConnectedSpace_iff_subsets_isOpen_isConnected]
  intro x F hF
  -- Extract an open neighbourhood `T ⊆ F` of `x`.
  obtain ⟨T, hTF, hT, hxT⟩ := mem_nhds_iff.mp hF
  -- Find an affine open `W ⊆ T` with `x ∈ W`.
  obtain ⟨W, hW, hxW, hWT⟩ :=
    exists_isAffineOpen_mem_and_subset (X := G.left) (U := ⟨T, hT⟩) hxT
  haveI : IsNoetherianRing Γ(G.left, W) :=
    IsLocallyNoetherian.component_noetherian ⟨W, hW⟩
  haveI hNoethW : TopologicalSpace.NoetherianSpace ↥W :=
    noetherianSpace_of_isAffineOpen W hW
  -- Inside `W` (Noetherian) the connected component of `x` is open; its image
  -- under the open inclusion `W ↪ G.left` is the connected open neighbourhood
  -- we want.
  let xW : ↥W := ⟨x, hxW⟩
  refine ⟨(Subtype.val : ↥W → G.left) '' connectedComponent xW, ?_, ?_, ?_, ?_⟩
  · rintro _ ⟨z, _, rfl⟩
    exact hTF (hWT z.2)
  · exact W.isOpen.isOpenMap_subtype_val _
      (noetherianSpace_isOpen_connectedComponent xW)
  · exact ⟨xW, mem_connectedComponent, rfl⟩
  · exact isConnected_connectedComponent.image _ continuous_subtype_val.continuousOn

/-- The image of the identity section `e : Spec k → G` (well-defined as a
single point of `|G|` because `Spec k` is a topological singleton). -/
private noncomputable def identitySectionPoint
    {k : Type u} [Field k] (G : Over (Spec (.of k))) [GrpObj G] : G.left :=
  ((MonObj.one (X := G)).left.base :
      ↥(Spec (.of k)) → G.left) (default : Spec (.of k))

/-- Helper (iter-186; iter-187 closed): the **clopen carrier `Set`** of
the identity component of a `k`-group scheme `G` locally of finite type,
packaged as a `G.left.Opens`. The carrier set is `connectedComponent x`
for `x = e(*)` the image of the identity section
(`identitySectionPoint G`); openness is `isOpen_connectedComponent` which
needs the `identityComponent_locallyConnectedSpace` instance above
(EGA I 6.1.9). -/
private noncomputable def identityComponentCarrier {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    G.left.Opens :=
  ⟨connectedComponent (identitySectionPoint G), isOpen_connectedComponent⟩

/-- The **identity component** `G^0` of a `k`-group scheme `G` locally of
finite type.

Encoded as a `k`-scheme: an object of `Over (Spec (.of k))`, carrying the
intended substantive identity "this is the connected component of `|G|`
containing the identity section `e`, equipped with the open-subscheme
structure inherited from `G`". The associated open immersion
`IdentityComponent G ⟶ G` is the content of
`IdentityComponent.isOpenSubgroupScheme`.

iter-186 body: built from the `identityComponentCarrier G` helper — the
open subscheme of `G` whose underlying topological space is the connected
component of `|G|` through the image of the identity section. The
structure morphism is the inherited `(identityComponentCarrier G).ι ≫ G.hom`.
The substantive content (the actual carrier `Set`, plus its openness from
EGA I 6.1.9: locally Noetherian spaces have open connected components)
lives in the typed-sorry body of `identityComponentCarrier`. -/
noncomputable def IdentityComponent {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    Over (Spec (.of k)) :=
  Over.mk ((identityComponentCarrier G).ι ≫ G.hom)

/-- **The identity component is an open and closed subgroup scheme.**

The bundled statement of Kleiman §5 Lem.~`lem:agps`~(3): the identity
component `G^0 = IdentityComponent G` of a `k`-group scheme `G` locally of
finite type comes with a morphism `IdentityComponent G ⟶ G` (in
`Over (Spec (.of k))`) whose underlying scheme morphism is both an open
immersion and a closed immersion (i.e. the inclusion of a clopen
subscheme).

The full Kleiman conclusion also packages the group-subscheme property (the
inclusion is a homomorphism of `k`-group schemes), finite-type-ness over `k`
(`LocallyOfFiniteType` + quasi-compactness), geometric irreducibility, and
base-change-commutation. Those refinements live as separate instances /
follow-up lemmas in iter-186+; the file-skeleton pins only the clopen
open-immersion conclusion as a Nonempty-witness.

iter-186 body: the inclusion morphism is `Over.homMk (identityComponentCarrier G).ι`,
with the over-category compatibility holding by definition of
`IdentityComponent G`. The `.left` of this morphism is
`(identityComponentCarrier G).ι`, an open immersion by the global
`Scheme.Opens.instIsOpenImmersionι` instance. For the closed-immersion
half we apply `IsClosedImmersion.of_isPreimmersion` to the open immersion
and reduce to `IsClosed (↑(identityComponentCarrier G) : Set _)`. The
remaining inline `sorry` is the substantive content: the carrier of
`identityComponentCarrier G` is closed, by "closure of a connected subspace
is connected" applied to the connected component through the image of the
identity section. -/
theorem IdentityComponent.isOpenSubgroupScheme {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    Nonempty {f : IdentityComponent G ⟶ G //
        IsOpenImmersion f.left ∧ IsClosedImmersion f.left} := by
  -- Over-category compatibility for the underlying open immersion.
  have hcomp : (identityComponentCarrier G).ι ≫ G.hom = (IdentityComponent G).hom := by
    simp [IdentityComponent]
  -- The over-morphism witness.
  let f : IdentityComponent G ⟶ G :=
    Over.homMk (U := IdentityComponent G) (V := G) (identityComponentCarrier G).ι hcomp
  refine ⟨⟨f, ?_, ?_⟩⟩
  · -- `f.left = (identityComponentCarrier G).ι` (definitionally; `Over.homMk_left` simp).
    -- An open immersion by `Scheme.Opens.instIsOpenImmersionι`.
    change IsOpenImmersion (identityComponentCarrier G).ι
    infer_instance
  · -- `f.left = (identityComponentCarrier G).ι` is a preimmersion (open immersion ⟹
    -- immersion ⟹ preimmersion). Its range is the carrier set (`Scheme.Opens.range_ι`),
    -- and closure of that connected subset is itself (Kleiman §5 Lem.~`lem:agps`~(3):
    -- the connected component through the identity is closed in `|G|`).
    change IsClosedImmersion (identityComponentCarrier G).ι
    apply IsClosedImmersion.of_isPreimmersion
    rw [Scheme.Opens.range_ι]
    -- The carrier set is `connectedComponent (identitySectionPoint G)`, which is
    -- closed by `isClopen_connectedComponent.1` (with the
    -- `identityComponent_locallyConnectedSpace` instance providing the closedness
    -- half of EGA I 6.1.9: connected components of a locally Noetherian topological
    -- space are clopen).
    change IsClosed (connectedComponent (identitySectionPoint G))
    exact isClopen_connectedComponent.1

/-! ### iter-192 Lane A.3.i: identity-component substrate

Per `analogies/lane-a3i-isconnected-prod.md`, the substrate for the
group-structure inheritance and base-change-commutation arguments is
Stacks Tag 04KU / EGA IV₂ 4.5.14 (a connected `k`-scheme with a
`k`-rational section is geometrically connected) combined with Mathlib's
`ConnectedSpace (pullback f g)` instance for
`[GeometricallyConnected f] [UniversallyOpen f] [ConnectedSpace Y]`.

This iter (Lane A.3.i): we add the AXIOM-CLEAN
`identityComponentCarrier_connectedSpace` helper below (the carrier is
connected by construction). The full Stacks 04KU bridge
"`ConnectedSpace X` + section ⟹ `GeometricallyConnected f`" requires
the Mathlib substrate "`X` connected with `k` algebraically closed in
`Γ(X, 𝒪_X)` ⟹ `X` geometrically connected over `k`" (Stacks 037Q +
04KU), not yet available in Mathlib at SHA b80f227 — pending that
Mathlib lemma, the geometric-connectedness step lives as a residual
sorry inside the downstream theorems
(`isSubgroupHomomorphism`, `baseChangeIso`, `isFiniteTypeGeometricallyIrreducible`).

Below: `baseChangeIso` partially closes via
`CategoryTheory.Over.grpObjMkPullbackSnd` (iter-192 axiom-clean closure
of 2 of the 3 conjuncts; the third conjunct, the iso of identity-component
constructions, remains sorry pending the Stacks 04KU substrate). -/

/-- Helper (iter-192 Lane A.3.i, axiom-clean): the **identity component
carrier** has connected underlying topological space.

The carrier is defined as `connectedComponent (identitySectionPoint G)`
in `|G|` (a `G.left.Opens`), and its subspace topology coincides with the
open-subscheme topology; the subspace is connected because the connected
component is preconnected (Mathlib's `isPreconnected_connectedComponent`)
and nonempty (contains the identity point `identitySectionPoint G`). -/
private instance identityComponentCarrier_connectedSpace
    {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    ConnectedSpace ((identityComponentCarrier G : G.left.Opens) : Type _) := by
  haveI : PreconnectedSpace ((identityComponentCarrier G : G.left.Opens) : Type _) :=
    Subtype.preconnectedSpace isPreconnected_connectedComponent
  exact ⟨⟨⟨identitySectionPoint G, mem_connectedComponent⟩⟩⟩

/-- Helper (iter-192 Lane A.3.i, axiom-clean): the **identity component**
`IdentityComponent G` has connected underlying topological space.

By definition `(IdentityComponent G).left` is the open subscheme
`identityComponentCarrier G : G.left.Opens` regarded as a scheme; its
underlying topological space coincides definitionally with the carrier's
subspace topology, so `ConnectedSpace` transports via
`identityComponentCarrier_connectedSpace` above.

Downstream this combines with the (pending) Stacks 04KU substrate
`GeometricallyConnected (IdentityComponent G).hom` plus Mathlib's
`ConnectedSpace (pullback f g)` instance for
`[GeometricallyConnected f] [UniversallyOpen f] [ConnectedSpace Y]`
to give the key "`G⁰ ×_k G⁰` is connected" substrate for Kleiman's
group-structure inheritance argument in `isSubgroupHomomorphism`. -/
private instance identityComponent_connectedSpace
    {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    ConnectedSpace (IdentityComponent G).left := by
  change ConnectedSpace ((identityComponentCarrier G : G.left.Opens) : Type _)
  infer_instance

/-- **The identity component inclusion is a group-scheme homomorphism.**

Kleiman §5 Lem.~`lem:agps`~(3) conclusion (b): the clopen subscheme `G^0`
inherits a `k`-group-scheme structure from `G`, and the inclusion morphism
`G^0 ↪ G` (from `IdentityComponent.isOpenSubgroupScheme`) is compatible
with the group laws on source and target. The statement-level pin asserts
the existence of the inherited `GrpObj` structure; the compatibility of
the inclusion with the group operations is the substantive content of
Kleiman's argument (the product `G^0 ×_k G^0` is connected by
EGA IV₂ 4.5.8; the group-multiplication map sends this connected subset
containing the identity into the connected component `G^0`).

The full statement (existence of `GrpObj (IdentityComponent G)` *together*
with the homomorphism-compatibility of the inclusion in the relevant
`Hom`-form) lives in iter-193+. -/
theorem IdentityComponent.isSubgroupHomomorphism {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    Nonempty (GrpObj (IdentityComponent G)) :=
  sorry

/-- **The identity component is of finite type and geometrically irreducible.**

Kleiman §5 Lem.~`lem:agps`~(3) conclusion (c): the open subgroup `G^0` of
a `k`-group scheme `G` locally of finite type is itself
locally-of-finite-type-plus-quasi-compact (i.e., of finite type) over `k`,
and is geometrically irreducible. The proof reduces (after base change to
`\bar k`) to picking a nonempty smooth affine open subset `U ⊆ G^0`; the
translates `hg⁻¹U` give an open cover of `G^0` by smooth, hence irreducible,
neighbourhoods, so `G^0` is locally irreducible at every closed point; with
connectedness this gives irreducibility globally (EGA I 6.1.10). The image
`α(U × U) = G^0` is the image of the affine, hence quasi-compact, scheme
`U × U`, so `G^0` is quasi-compact.

iter-189 partial progress: the `LocallyOfFiniteType` conjunct closes
axiom-clean via composition of an open immersion with `G.hom`. The
remaining two conjuncts (`QuasiCompact`, `GeometricallyIrreducible`)
require the group-structure argument and are bundled into the residual
sorry. -/
theorem IdentityComponent.isFiniteTypeGeometricallyIrreducible
    {k : Type u} [Field k]
    (G : Over (Spec (.of k)))
    [GrpObj G] [LocallyOfFiniteType G.hom] :
    LocallyOfFiniteType (IdentityComponent G).hom ∧
      QuasiCompact (IdentityComponent G).hom ∧
      GeometricallyIrreducible (IdentityComponent G).hom := by
  refine ⟨?_, ?_⟩
  · -- `LocallyOfFiniteType`: `(IdentityComponent G).hom` unfolds to
    -- `(identityComponentCarrier G).ι ≫ G.hom`. Open immersion ∘ LFT
    -- is LFT (`locallyOfFiniteType_of_isOpenImmersion` +
    -- `locallyOfFiniteType_comp`).
    change LocallyOfFiniteType ((identityComponentCarrier G).ι ≫ G.hom)
    infer_instance
  · -- `QuasiCompact ∧ GeometricallyIrreducible`: Kleiman's group-theoretic
    -- argument. `α(U × U) = G^0` quasi-compact via the affine `U × U`;
    -- geometric irreducibility via base change to `\bar k`, picking a
    -- smooth affine `U ⊆ G^0`, and translating `hg⁻¹U` to cover. Cannot
    -- close axiom-clean without the substrate `isSubgroupHomomorphism`
    -- + EGA IV₂ 4.5.8 / 4.6.1 / EGA I 6.1.10 (not yet in Mathlib).
    sorry

/-- **Formation of the identity component commutes with base change.**

Kleiman §5 Lem.~`lem:agps`~(3) conclusion (d): for any field extension
`K/k`, the natural comparison map `(G^0)_K → (G_K)^0` is an isomorphism of
`K`-schemes. The proof: `G^0` is geometrically connected as a connected
scheme with a `k`-rational point (EGA IV₂ 4.5.14), so its base change
`(G^0)_K` remains connected; it is also open and closed in `G_K`, so
coincides with the identity component `(G_K)^0`.

The statement-level pin asserts existence of: a `K`-group-scheme structure
on the base change `G ×_{Spec k} Spec K` (with appropriate
locally-of-finite-type instance), and an isomorphism on underlying schemes
identifying the two iterated constructions.

iter-192 partial closure (Lane A.3.i, axiom-clean modulo the iso slot):
the `_grpInst` slot closes via `CategoryTheory.Over.grpObjMkPullbackSnd`
(per `analogies/lane-a3i-isconnected-prod.md` second analogue — the
category-theoretic base-change of `GrpObj` directly fitting the
`Over.mk (pullback.snd ...)` shape of `G_K`); the `_locFTInst` slot
closes via Mathlib's stability of `LocallyOfFiniteType` under base
change (`inferInstance` fires on the pullback). The remaining iso slot
`(IdentityComponent G_K).left ≅ pullback (IdentityComponent G).hom φ`
is the substantive content of Stacks 04KS / EGA IV₂ 4.5.16: identifying
the iterated identity-component construction with the base change of
the identity component, which requires the
`geometricallyConnected_of_connected_of_section` helper above plus
descent of clopen partitions along base change (not yet in Mathlib). -/
theorem IdentityComponent.baseChangeIso {k : Type u} [Field k]
    (G : Over (Spec (.of k))) [GrpObj G] [LocallyOfFiniteType G.hom]
    (K : Type u) [Field K] [Algebra k K] :
    let φ : Spec (CommRingCat.of K) ⟶ Spec (CommRingCat.of k) :=
      Spec.map (CommRingCat.ofHom (algebraMap k K))
    let G_K : Over (Spec (CommRingCat.of K)) :=
      Over.mk (CategoryTheory.Limits.pullback.snd G.hom φ)
    Nonempty (Σ' (_grpInst : GrpObj G_K)
                 (_locFTInst : LocallyOfFiniteType G_K.hom),
      (IdentityComponent G_K).left ≅
        CategoryTheory.Limits.pullback (IdentityComponent G).hom φ) := by
  intro φ G_K
  -- `GrpObj G_K` via the category-theoretic base-change lemma
  -- `CategoryTheory.Over.grpObjMkPullbackSnd`. The instance bridge
  -- `[GrpObj G] ⟹ [GrpObj (Over.mk G.hom)]` is by defeq (`G = Over.mk G.hom`
  -- when `G` is an over-category object whose right component is the unique
  -- inhabitant of `Discrete PUnit`).
  haveI hG : GrpObj (Over.mk G.hom) := ‹GrpObj G›
  haveI hGK_grp : GrpObj G_K := CategoryTheory.Over.grpObjMkPullbackSnd
  -- `LocallyOfFiniteType G_K.hom`: `G_K.hom = pullback.snd G.hom φ` is the
  -- base change of `G.hom` along `φ`; `LocallyOfFiniteType` is stable
  -- under base change (Mathlib instance).
  haveI hGK_lft : LocallyOfFiniteType G_K.hom :=
    (inferInstance : LocallyOfFiniteType (CategoryTheory.Limits.pullback.snd G.hom φ))
  -- The iso slot remains a typed sorry (Stacks 04KS / EGA IV₂ 4.5.16 +
  -- the `geometricallyConnected_of_connected_of_section` helper).
  refine ⟨⟨hGK_grp, hGK_lft, ?_⟩⟩
  sorry

end GroupScheme

/-! ## §2. The identity component of the Picard scheme

We specialise the abstract identity-component substrate to
`G = PicScheme C`, the Picard scheme of a smooth proper geometrically
integral curve `C/k` (from sibling `Picard/FGAPicRepresentability.lean`).

Blueprint reference: `def:pic_zero_subscheme` (Kleiman §5 opening + Prp.
`prp:pic0`). -/

namespace Scheme

/-- The **identity component of the Picard scheme** `Pic⁰_{C/k}`.

Defined as the identity component
`GroupScheme.IdentityComponent (PicScheme C)` of the Picard scheme
`Pic_{C/k}` (from sibling `Picard/FGAPicRepresentability.lean`,
`AlgebraicGeometry.Scheme.PicScheme`). By
`GroupScheme.IdentityComponent.isOpenSubgroupScheme`, `Pic⁰_{C/k}` is an
open and closed subgroup scheme of `Pic_{C/k}` of finite type over `k`,
geometrically irreducible, and its formation commutes with extension of the
base field.

iter-186+: the body unwinds to `GroupScheme.IdentityComponent (PicScheme C)`
once the `[LocallyOfFiniteType (PicScheme C).hom]` instance lands on
`PicScheme C` (it follows from the Kleiman §4 structure: `Pic_{C/k}` is
locally of finite type as the disjoint union of open quasi-projective
`k`-subschemes). For the iter-185 file-skeleton the body is a typed `sorry`. -/
noncomputable def Pic0Scheme {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    Over (Spec (.of k)) :=
  sorry

/-! ## §3. The degree map

The disjoint-union structure of `Pic_{C/k}` (a disjoint union of open
quasi-projective `k`-subschemes, indexed by Hilbert polynomial via
`PicScheme.smoothProperQuotient`) stratifies its `T`-points by the leading
coefficient of the Hilbert polynomial of a representing invertible sheaf
relative to a fixed degree-one polarisation. On `k`-points this gives the
**degree map** `Pic_{C/k}(k) → ℤ`.

Blueprint reference: `def:divisor_degree_pic` (Milne III.1, p.~88). -/

namespace PicScheme

/-- The **degree map** `Pic_{C/k}(k) → ℤ`.

Sends a `k`-point `λ ∈ Pic_{C/k}(k)` --- a morphism
`Spec k ⟶ (PicScheme C).left` --- to the leading coefficient of the
Hilbert polynomial of a representing invertible sheaf `L` on `C` (relative
to a fixed degree-one polarisation `O_C(1)`). By Riemann--Roch,
`χ(C, L ⊗ O_C(n)) = n · deg L + 1 - g`, so the degree is the leading
coefficient of `Φ_L(n)`, well-defined on the isomorphism class `[L]` and on
the `k`-point `λ` (because `PicScheme C` represents the étale-sheafified
relative Picard functor).

The degree map is a group homomorphism for the additive structure on
`Pic_{C/k}(k)` (tensor product on `L`) and the standard `(ℤ, +)`. The full
group-homomorphism refinement / functoriality in `k` lives as a follow-up
lemma in iter-186+; the file-skeleton pins only the underlying function.

iter-186+: the body extracts the representing invertible sheaf from
`(PicScheme.representable C)`, forms its Hilbert polynomial via the project's
Hilbert-polynomial machinery (sibling `Picard/QuotScheme.lean`), and returns
the leading coefficient. For the iter-185 file-skeleton the body is a typed
`sorry`. -/
noncomputable def degree {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    (Spec (.of k) ⟶ (PicScheme C).left) → ℤ :=
  sorry

end PicScheme

/-! ## §4. `Pic⁰_{C/k}` is an abelian variety

The terminal statement of the chapter identifies `Pic⁰_{C/k}` with an
abelian variety of dimension `g(C)` --- the Jacobian variety of `C`. In
this project, "abelian variety" is the conjunction of the four properties
`[GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]`
threaded through `AlgebraicJacobian.AbelianVarietyRigidity` and consumed by
`AlgebraicJacobian.Albanese.AlbaneseUP`.

Blueprint reference: `thm:pic_zero_is_abelian_variety` (Kleiman §5
Ex.~`ex:jac` + Rmk.~`rmk:Jac`; cf. Milne §I.1, Rmk. III.1.4(e)). -/

namespace Pic0Scheme

/-- **`Pic⁰_{C/k}` is an abelian variety.**

For `C/k` a smooth proper geometrically integral curve of genus `g = g(C)`
over a field `k`, the identity component `Pic⁰_{C/k}` of the Picard scheme
is an *abelian variety over* `k`: a smooth, proper, geometrically
irreducible `k`-group scheme. (Commutativity follows automatically from
Milne §I.1, Cor. 1.4, and is not separately stated here.)

The bundled statement: the four pieces `[IsProper] ∧ [Smooth] ∧
[GeometricallyIrreducible] ∧ Nonempty (GrpObj _)` hold on
`(Pic0Scheme C).hom` and `(Pic0Scheme C)` respectively.

Dimension `g = g(C)`: not stated separately at the file-skeleton level
(it requires `dim_k (Pic0Scheme C).left = AlgebraicGeometry.genus C`, which
involves the Krull-dimension API on the underlying scheme); iter-186+
follow-up.

iter-186+: the body assembles the four conjuncts from
- `GroupScheme.IdentityComponent.isOpenSubgroupScheme` (clopen subscheme of
  `PicScheme C`),
- Kleiman §5 Thm.~`th:qpp&p` (`X/k` projective + geom. integral ⟹
  `Pic⁰_{X/k}` quasi-projective; upgrade to projective when geom. normal,
  which holds for smooth proper curves of positive genus),
- Kleiman §5 Cor.~`cor:sm` + Ex.~`ex:jac` (smoothness of `Pic_{X/k}` at the
  identity for smooth proper curves; hence smooth of dimension
  `dim_k H¹(C, O_C) = g(C)` everywhere by uniform smoothness on the open
  identity component).
For the iter-185 file-skeleton the body is a typed `sorry`. -/
theorem isAbelianVariety {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
      GeometricallyIrreducible (Pic0Scheme C).hom ∧
      Nonempty (GrpObj (Pic0Scheme C)) :=
  sorry

/-- **Dimension of `Pic⁰_{C/k}` equals the genus of `C`.**

Milne~§III.1, Rmk.~1.4(e): "The dimension of `J` is the genus of `C`".
For a smooth proper geometrically integral curve `C/k` of genus
`g = g(C)`, the topological Krull dimension of the underlying scheme of
`Pic⁰_{C/k}` equals `g(C)`. By Kleiman~§5 Cor.~`cor:sm`, the inequality
`dim Pic_{C/k} ≤ dim_k H¹(C, O_C)` is always an equality at points where
`Pic_{C/k}` is smooth, and for smooth proper curves
(`SmoothOfRelativeDimension 1 C.hom`) the identity component is smooth
(Kleiman~§5 Ex.~`ex:jac`), so the dimension equals `dim_k H¹(C, O_C) = g(C)`
by `def:genus`. -/
theorem finrank_eq_genus {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    topologicalKrullDim (Pic0Scheme C).left = (AlgebraicGeometry.genus C : WithBot ℕ∞) :=
  sorry

/-- **`k`-points of `Pic⁰_{C/k}` are the kernel of the degree map.**

Milne~§III.1, p.~88: `Pic⁰(C)` is the group of isomorphism classes of
invertible sheaves of degree zero on `C`. For a smooth proper geometrically
integral curve `C/k`, a `k`-point `λ ∈ Pic_{C/k}(k)` lies in the image of
the inclusion `Pic⁰_{C/k} ↪ Pic_{C/k}` (the inclusion of
`def:pic_zero_subscheme`, packaged here via the existence of the
inclusion morphism) if and only if `degree C λ = 0`.

The statement-level pin packages two pieces: existence of the inclusion
morphism `Pic⁰_{C/k} ⟶ Pic_{C/k}` (extracted from
`IdentityComponent.isOpenSubgroupScheme` once `PicScheme C` has the
`GrpObj` + `LocallyOfFiniteType` instances), together with the
characterisation of `k`-points factoring through it as those with degree
zero. -/
theorem kPoints_iff_kerDegree {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    Nonempty (Σ' (inc : (Pic0Scheme C).left ⟶ (PicScheme C).left),
      ∀ (lambda : Spec (.of k) ⟶ (PicScheme C).left),
        (∃ mu : Spec (.of k) ⟶ (Pic0Scheme C).left, mu ≫ inc = lambda) ↔
          PicScheme.degree C lambda = 0) :=
  sorry

end Pic0Scheme

end Scheme

end AlgebraicGeometry
