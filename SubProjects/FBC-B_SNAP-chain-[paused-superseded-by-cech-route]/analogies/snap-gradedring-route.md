# Analogy: graded section ring `⊕ Γ(X,L^{⊗n})` associativity WITHOUT an object-level associator pentagon

## Mode
cross-domain-inspiration

## Slug
snap-gradedring-route

## Iteration
027

## Structural problem (abstracted)
`C` monoidal (coherent presheaf monoidal), `L : C ⥤ D` a reflective localization (sheafification),
`D = X.Modules` NOT a Mathlib `MonoidalCategory`. Build a `DirectSum.GCommSemiring` on the family
`A_n = Φ(L(P^{⊗n}))` (`Φ = Γ(X,-)`), with degreewise mult `A_a ⊗ A_b → A_{a+b}` = lax section
pairing `sectionsMul` followed by `Γ(μ_{a,b})` (the tensor-power comparison `tensorPowAdd`).
The blocker is the **coherence** (`mul_assoc`/unit/comm) of this multiplication, currently reduced
to pentagon/triangle/hexagon for the hand-built sheaf tensor — a hard `whnf`-bomb wall.

## CRITICAL STRUCTURAL FINDING (read before the analogues)
**Verified by reading `AlgebraicJacobian/Picard/SectionGradedRing.lean` this iter.**

1. `tensorObjAssoc` (the associator **morphism/iso**, `def` L1317) is built **directly** from the
   closed crux `isIso_sheafification_whiskerRight_unit` and is **SORRY-FREE**. The sheaf-level
   associator EXISTS as a morphism. The strong-monoidality brick is already discharged.
2. The walled bridge `tensorObjAssoc_eq_localizedAssociator` (sorry at L2314 in
   `tensorObjAssoc_hK_lhs_native`) and the whole localized-monoidal apparatus
   (`modulesLocalizedMonoidal`, `tensorObjLocalizedIso`, the `hK_lhs/hK_rhs` seams, L1438–2662)
   is referenced **ONLY inside its own definition block** — last reference is L2662. **Nothing in
   the tensor-power / section-coherence / graded-assembly region (L2700–3341) consumes it.**
   ⇒ The ~15-iter `μ`-token / dual-instance wall (`tensorObjAssoc_hK_lhs_native`,
   [[snap-mu-identity]], [[snap-reassoc-pin]], [[snap-route]]) is **OFF the critical path** to
   `sectionGradedRing_gcommSemiring`. It can be left as a typed `sorry` (or deleted) forever.
3. `sectionMul_assoc_core` (L~3007, **CLOSED sorry-free**) already proves the associativity ride
   at the **section/element level** by "riding `η`": expand `tensorObjAssoc` into its 5 segments,
   push `η` through each via `η`-naturality, land on the presheaf associator `α_p` which
   rebrackets `(σ⊗τ)⊗υ ↦ σ⊗(τ⊗υ)` definitionally at the top open. This IS the TensorPower
   `mul_assoc`-on-generators step, already working.
4. The 5 REAL blocking sorries (all in L3126–3243): `tensorPowAdd_rightUnit` succ (L3143),
   `tensorPowAdd_braiding` succ (L3165), `tensorPowAdd_assoc` base+succ (L3180/3183),
   `sectionsMul_mul_assoc` (L3243). The first four are **object-level iso equations** (equations
   between isos in `X.Modules`, proving Mac Lane coherence transferred through `tensorObjAssoc` by
   induction) — genuinely hard. `sectionsMul_mul_assoc` currently routes through
   `tensorPowAdd_assoc`, so it inherits the object-level pentagon.

**The recommendation below removes the need for the four object-level iso equations entirely.**

## Failed approaches (from directive — NOT to re-suggest)
- Object-level bridge hand-built `tensorObj` → `⊗_loc`: 10-iter μ-divergence wall. (= the off-path
  apparatus in finding 2.)
- Re-base `tensorObj := tensorObj (C := ⊗_loc)`: kernel type-mismatch (not defeq). DEAD.
- Full hand-rolled `MonoidalCategory X.Modules`: DEAD.
- Stalkwise/elementwise descent of the OBJECT coherence: DEAD (no module-sheaf stalk infra).

## Analogues found (ranked by porting cost, lowest first)

### Analogue 1: `Mathlib.LinearAlgebra.TensorPower.Basic` — graded `mul_assoc` on GENERATORS by a concrete identity  [TOP]
- **Citation**: `TensorPower.gmonoid`, `TensorPower.gsemiring`, `TensorPower.mul_assoc`,
  `TensorPower.mulEquiv`, `TensorPower.cast`, `TensorPower.tprod_mul_tprod`
  (`Mathlib.LinearAlgebra.TensorPower.Basic`). Also `DirectSum.gradedMonoid_eq_of_cast` (the bridge
  the project's `gradedMonoid_eq_of_cast` mirrors).
- **Domain**: multilinear algebra / graded algebra (concrete `ModuleCat R`).
- **Same problem there**: build `DirectSum.GCommSemiring (fun n => ⨂[R]^n M)` where mult is
  `⨂^a M ⊗ ⨂^b M ≃ ⨂^{a+b} M`. Identical shape to SNAP (`⨂^n M ↔ Γ(L^{⊗n})`,
  `mulEquiv ↔ Γ(μ)∘sectionsMul`, `TensorPower.cast ↔ sectionsCast`).
- **Technique** (the porting key): `TensorPower.mul_assoc` is proved by (a) reducing both
  bracketings to **generators** = pure tensors `tprod`, where mult is the concrete
  `tprod_mul_tprod` (mult of two pure tensors = one pure tensor reindexed by `finSumFinEquiv`);
  (b) the associativity of generators is the **concrete combinatorial identity `Fin.append_assoc`**
  on `Fin ((a+b)+c)` — NOT a categorical pentagon; (c) extend from generators to all elements by
  `ext` / `PiTensorProduct.induction_on` (multilinearity). Assembly is **verbatim** what SNAP
  already has at L3277–3322:
  `mul_assoc := fun _ _ _ => gradedMonoid_eq_of_cast (add_assoc _ _ _) (mul_assoc _ _ _)`.
- **Mapping to project** (this is the route):
  * SNAP generators = elementary sections `σ ⊗ τ ↦ sectionsMul = η(σ ⊗_p τ)` (def of `sectionsMul`,
    L196). `sectionsMul` is `TensorProduct`-bilinear, so `ext`/`map_add`/`map_smul` extend
    generator identities to all elements (the `instGSemiring` `mul_add`/`add_mul` fields at
    L3304–3311 are already this, proved sorry-free).
  * SNAP analogue of `tprod_mul_tprod` = a **per-degree intertwiner**
    `μΓ_collapse : Γ(μ_{m,m'}).app⊤ ∘ sectionsMul = Γ(η_{m+m'}) ∘ (presheaf-tensor-power mult)`,
    i.e. "the graded mult of two `η`-images is the `η`-image of the presheaf elementary tensor in
    `(P_L^{⊗(m+m')})(⊤)`". Proved by induction on the degree, the inductive step being exactly the
    `sectionMul_assoc_core` "ride `η` through `tensorObjAssoc`" move (already closed) — an equation
    of **functions on sections**, element-wise, never an iso equation.
  * SNAP analogue of `Fin.append_assoc` = `sectionMul_assoc_core` (**CLOSED**): the presheaf
    associator `α_p` rebrackets the elementary tensor at the top open. Likewise unit branch =
    `unitor_sectionsMul` (closed), comm branch = `sectionMul_braiding_core` (closed). All three
    generator-level cores already exist.
  * With `μΓ_collapse` in hand, **all four** `sectionsMul_{one_mul,mul_one,mul_assoc,mul_comm}`
    discharge by pushing the concrete `TensorProduct.assoc`/unit/comm of the presheaf tensor power
    at ⊤ through `Γ(η)` — and the four object-level iso lemmas `tensorPowAdd_{assoc,braiding,
    rightUnit}` (sorries L3143/3165/3180/3183) are **never needed**; only `tensorPowAdd_zero`
    (the `m=0` defn unfold, already closed) and `μΓ_collapse` enter.
- **Porting cost**: **medium, lowest available**. New infra = the single inductive intertwiner
  `μΓ_collapse` (degree induction, each step = closed `sectionMul_assoc_core`-style `η`-ride) +
  re-prove the four section coherences as `Γ(η)`-pushforwards. Reuses 3 already-closed cores and
  the closed sorry-free `tensorObjAssoc` morphism. Deletes dependence on the 4 object-iso pentagons
  AND the off-path localized bridge.
- **Why this dodges the wall**: associativity becomes an equality of **elements** in the single
  module `Γ(L^{⊗(a+b+c)})`, both sides `Γ(η)`-images of the two bracketings of a presheaf
  elementary tensor, which are equal by `TensorProduct.assoc` (concrete). `Γ(η)` need NOT be
  iso/surjective — pushing an equation FORWARD along any function suffices. (This is precisely the
  gap in the prior [[snap-route]] "irreducibility" claim, which conflated *transporting the ring
  structure* (needs iso) with *pushing one equation forward* (needs only a map). The structure is
  built honestly via the already-closed strong monoidality; only the coherence equations move
  forward.)
- **Verdict**: ANALOGUE_FOUND.

### Analogue 2: `CategoryTheory.Functor.mapMon` / `Functor.monObjObj` — lax monoidal functor preserves monoid objects
- **Citation**: `CategoryTheory.Functor.mapMon`, `CategoryTheory.Functor.monObjObj`,
  `CategoryTheory.Functor.mapMonFunctor` (`Mathlib.CategoryTheory.Monoidal.Mon_`). Associativity of
  the image monoid is the functor's `LaxMonoidal.associativity` field composed with source
  associativity.
- **Domain**: category theory (monoid objects in monoidal categories).
- **Same problem there**: a `[F.LaxMonoidal]` functor sends a `MonObj X` to `MonObj (F.obj X)` —
  the abstract statement "associativity of the image multiplication comes from the lax structure +
  source associativity", which is the principled version of the η-ride.
- **Technique**: bundle the multiplication as a monoid object; `associativity`/`left_unitality`/
  `right_unitality` of the lax functor discharge the image's monoid axioms automatically.
- **Mapping to project**: NOT directly instantiable. The section ring is **graded** (`⊕_n`), not a
  single monoid object, and forming the monoid object `⊕_n L^{⊗n}` in `X.Modules` (or stating
  `M ⊗ M → M`) needs a `MonoidalCategory X.Modules` — the wall. Using the presheaf monoid (tensor
  algebra on `P_L`, which IS a `Mon_` in the monoidal `PresheafOfModules`) and `Γ∘sh` lax gives
  the WRONG ring (`T(Γ_pre L)`; sheafification changes sections — [[snap-route]] point 1). It is
  nonetheless the conceptual justification that Analogue 1's per-degree η-ride is sound: Analogue 1
  is the hands-on, degree-indexed unrolling of `monObjObj` that sidesteps needing the global
  monoidal structure on `X.Modules`.
- **Porting cost**: high (would require the absent `MonoidalCategory X.Modules` to instantiate).
- **Verdict**: PARTIAL_ANALOGUE (right principle, not portable as an instance; use as the
  correctness argument for Analogue 1).

### Analogue 3: `TensorAlgebra` grading / `TensorProduct.gradedMul_assoc` — supporting precedents
- **Citation**: `TensorAlgebra.gradedAlgebra` (`Mathlib.LinearAlgebra.TensorAlgebra.Grading`),
  `TensorProduct.gradedMul_assoc` (`Mathlib.LinearAlgebra.TensorProduct.Graded.External`),
  `GradedTensorProduct.instRing` (`...Graded.Internal`).
- **Domain**: graded algebra.
- **Same problem there**: graded-ring `mul_assoc` from a family `A_i × A_j → A_{i+j}`, discharged
  by an explicit calculation (in `gradedMul_assoc`, via the `Additive ℤˣ` cocycle and
  `DirectSum.GAlgebra`), NOT a categorical pentagon. Reconfirms the directive's angle-3 thesis that
  every Mathlib graded ring proves `mul_assoc` on representatives.
- **Mapping**: corroborates Analogue 1's assembly target (`DirectSum.GCommSemiring` from
  cast-mediated component equalities) and that `gradedMonoid_eq_of_cast` is the canonical bridge.
- **Porting cost**: n/a (precedent, not a route).
- **Verdict**: ANALOGUE_FOUND (corroborating; Analogue 1 is the concrete instance to copy).

## Top suggestion
**Port Analogue 1 (`TensorPower.mul_assoc` technique) and DROP the object-level iso pentagons.**
Concretely, in `AlgebraicJacobian/Picard/SectionGradedRing.lean`:
1. Add one helper `μΓ_collapse (m m')` : `Γ(μ_{m,m'}).app⊤ ∘ sectionsMul = Γ(η_{m+m'}) ∘ (presheaf
   n-fold tensor mult at ⊤)` — by induction on the degree, the step a `sectionMul_assoc_core`-style
   `η`-ride through the sorry-free `tensorObjAssoc` morphism (element-wise, no iso equation).
2. Re-prove `sectionsMul_mul_assoc` (L3243), `sectionsMul_one_mul`, `sectionsMul_mul_one`,
   `sectionsMul_mul_comm` as `Γ(η)`-pushforwards of the concrete presheaf-tensor-power
   `TensorProduct.assoc`/unit/comm at ⊤, using `μΓ_collapse` + the three already-closed cores
   (`sectionMul_assoc_core`, `unitor_sectionsMul`, `sectionMul_braiding_core`). This bypasses
   `tensorPowAdd_assoc`/`tensorPowAdd_braiding`/`tensorPowAdd_rightUnit` entirely.
3. Leave `tensorObjAssoc_hK_lhs_native` (L2314) and the localized-monoidal bridge as a typed sorry
   or delete the block — finding 2 proves it is off the critical path; the planner should STOP
   pouring iters into it.
Read in Mathlib: `Mathlib/LinearAlgebra/TensorPower/Basic.lean` (`mul_assoc`, `tprod_mul_tprod`,
`mulEquiv`, `cast`, `gmonoid`) for the exact generator + `ext` + `gradedMonoid_eq_of_cast` shape;
the project's L3277–3322 assembly is already a line-for-line match, so only the four
`sectionsMul_*` proof bodies change.

## Discarded
- Re-proving `tensorPowAdd_assoc`/`_braiding`/`_rightUnit` as object-level iso equations (current
  L3170/3149/3126 route): unnecessary under Analogue 1, and the inductive steps re-incur the
  object-pentagon difficulty. Drop in favour of the section-level `Γ(η)`-pushforward.
- `tensorObjAssoc_eq_localizedAssociator` / `LocalizedMonoidal` bridge: off critical path
  (finding 2); = the directive's already-failed approaches. Do not continue.
- Presheaf section ring `⊕ P_L^{⊗m}(⊤)` then Γ (route (b)): wrong object (`T(Γ_pre L)`); but note
  the CORRECTED nuance — you do NOT take this as the ring, you only push the *equation* forward via
  the non-surjective `Γ(η)`; that is exactly Analogue 1 and it is sound.
- Building `MonoidalCategory X.Modules` to use `mapMon` directly: the wall; Analogue 2 is the
  justification, not the route.
