# SPEC DAT-1 — the m-chart glued constructor (`AJCR.w4-rep.datum.dat1`)

*Derived from the BINDING worksheet `informal/w4-datum-worksheet.md` (§3.2 input datum,
§4 DAT-1 staging (1a)–(1f) + sanctioned fallback, §2.2.1/§2.3 consumers, §5 risk 3).
Templates inherited verbatim: `Cohomology/TwistedSheaf.lean` (the 2-chart constructor),
`RigidEngine4{Assembly,AEval,Twist,Relative,Engine,BaseChange}.lean`,
`RelativeH1BaseChange.lean`. Mathlib pins verified by grep against the v4.31.0 checkout
(`.lake-packages/mathlib`), cited below. Kernel discipline: handoffs 07-14/14b/15
(binding): zero sorries, explicit binders, opaque/named ≤-lemmas, files ≤ 500 lines,
`set_option autoImplicit false`, lake mutex `flock /tmp/claude-1001/ajcr-locks/lake.lock`,
keystones `lean_verify` with axioms exactly `[propext, Classical.choice, Quot.sound]`.*

## 0. The input datum (worksheet §3.2, VERBATIM — binding)

> **Cocycle datum over a `k`-algebra `B`**: a finite index `J = J₀ ⊕ J₁`; for `j ∈ Jᵢ`
> an element `h_j ∈ Γ(Vᵢᴮ, 𝒪)` with partition witnesses `1 = Σ_j a_j·h_j` in
> `Γ(Vᵢᴮ, 𝒪)` (the basic opens `D(h_j)` cover the affine chart `Vᵢᴮ`); transition units
> on the pairwise basic-open overlaps given with explicit inverse witnesses; the cocycle
> identities as equalities in overlap section rings. Every carrier ring is
> `Γ(W, 𝒪_{C_B})` for `W` a pinned-chart open or a basic open thereof.

Here `Vᵢᴮ := (relCover C B (fiberTwoCover π)).Vᵢ` (the pinned relative cover,
`RigidEngine4Relative.lean:75`), `C_B := relCurve C B`. Lean spelling decisions:

- "finite index `J = J₀ ⊕ J₁`": fields `J₀ J₁ : Type u` with `Fintype` instances; the
  gluing index is literally `J₀ ⊕ J₁`.
- "explicit inverse witnesses": the transition units are `Γ(C_B, piece i ⊓ piece j)ˣ`
  (mathlib `Units` bundles the inverse witness).
- "basic opens": piece spelling is **`X.basicOpen (h j)`** for `h j : Γ(X, Vᵢᴮ)` — never
  the `Vᵢᴮ ⊓ D(h j)` spelling (they are equal opens; the `basicOpen` spelling is the one
  mathlib's `IsAffineOpen.isLocalization_basicOpen` lands on, killing a ring-iso
  transport per use). `X.basicOpen (h j) ≤ Vᵢᴮ` is `Scheme.basicOpen_le`, free.
- "partition witnesses": stored as `a : J → Γ(Vᵢᴮ)` with `∑ j, a j * h j = 1`; chart
  coverage `Vᵢᴮ ≤ ⨆ j, D(h j)` is DERIVED (lemma `le_iSup_basicOpen_of_sum_eq_one`
  below), not stored.
- cocycle identities: `Prop`-structure `Scheme.IsGluingCocycle` (§1a below) — includes
  the normalization `g i i = 1` (stored, not derived; constructors supply it trivially).

## 1. Architecture — five decisions

**(D1) The constructor is generic** in: a commutative ring `k` with `[X.Over (Spec (.of
k))]`, an arbitrary index `J : Type u` (finiteness enters only in (1b)/(1c)), an
arbitrary family `U : J → X.Opens`, and multipliers `g : ∀ i j, Γ(X, U i ⊓ U j)ˣ`. The
carrier needs NO cocycle law (matching is restriction-stable for any multipliers); the
trivializations consume `IsGluingCocycle`. This serves DAT-3 (field-level data), DAT-C,
and the pinned datum uniformly.

**(D2) Sections are Π-submodules, mirror of `twistSubmodule`**:
`F(W) = {s ∈ Π j, Γ(X, W ⊓ U j) | ∀ i j, s i↾ = g i j↾ · s j↾ on W ⊓ U i ⊓ U j}`,
`k`-action componentwise `Scheme.overModule`. Defined directly as a `Submodule` (no
defect map — the m-chart defect target is a Π-of-Π, worse spelling). Named ≤-lemmas
(house rule) for the three inclusions `W ⊓ U i ⊓ U j ≤ W ⊓ U i / W ⊓ U j / U i ⊓ U j`.

**(D3) QcohOn on a chart `V` is COMPONENTWISE, (P2) by partition-localization** (the
worksheet's "(P1) componentwise; (P2) pure localization algebra"). The action of
`r : Γ(X, V)` on `F(W)`, `W ≤ V`, is `(r • s) j := r↾_{W ⊓ U j} · s j`. The (P2) axioms
are proved under the **trivializing-family interface** (the abstract form of one side of
the datum):

```
(ι : Type u) [Fintype ι] (σ : ι → J) (h : ι → Γ(X, V))
(hbo : ∀ i, U (σ i) = X.basicOpen (h i)) (hcov : V ≤ ⨆ i, X.basicOpen (h i))
```

(No injectivity of `σ`; repeats harmless.) Proof shape for denominator clearing at
affine `V' ≤ V`, `q : Γ(X, V)`, `c ∈ F(V' ⊓ D(q))`: trivialize on the pieces
`(V' ⊓ U (σ i)) ⊓ D(q)`; clear denominators per piece
(`IsAffineOpen.exists_res_eq_pow_mul`, `AffineCech.lean:100` — `V' ⊓ U (σ i)` is affine:
it is `X.basicOpen (h i↾_{V'})` via `Scheme.basicOpen_resHom`, then
`IsAffineOpen.basicOpen`); uniformize `N := Finset.univ.sup`; kill the matching defects
on the affine double overlaps `V' ⊓ U (σ i) ⊓ U (σ i')`
(= `basicOpen (h i * h i'↾)` via `Scheme.basicOpen_mul`;
`IsAffineOpen.exists_pow_mul_eq_zero_of_res_eq_zero`, `AffineCech.lean:121`); uniformize
`M`; untrivialize and glue in `F` over the cover `{V' ⊓ U (σ i)}` of `V'`
(`TopCat.Sheaf.existsUnique_gluing'` on the glued sheaf); compare with
`q^{N+M} • c` locally (`TopCat.Sheaf.eq_of_locally_eq'` + the qsmul/triv compat lemma).
Annihilation is the same skeleton, shorter.

**(D4) The engine layer is REUSED, not mirrored**: `RigidEngine4Assembly` is generic in
the sheaf. Once DAT-1 supplies `QcohOn F Vᵢᴮ` + `Scheme.TwoCoverPairData` (componentwise
coordinate actions — NOTE: for the glued sheaf the mutual-inverse law is componentwise
ring algebra, EASIER than the 2-chart conjugation) + `AEval'` finiteness +
flat/projective section modules, the keystones `rigidEngine`,
`rigidEngine_isOpen_vanishing`, `h0TensorEquiv`, `h0BaseChangeEquiv` (abstract kernel
form) fire verbatim. Only the ON-THE-NOSE base change (1d-ii) needs new geometry.

**(D5) Chart-module structure via the RE-0 bridge + localization-local properties.**
`F(V)` is a `Γ(X, V)`-module via `Scheme.QcohOn.moduleOfLE` (`RigidEngine0Toolkit.lean:71`,
local instance); for each trivializing piece,
`secResₗ : F(V) → F(D(h i))` is an `IsLocalizedModule (Submonoid.powers (h i))`
(RE-0 bridge `isLocalizedModule_secResₗ` `RigidEngine0Toolkit.lean:109`, unit-action
hypothesis via the trivialization conjugated onto `isUnit_res_basicOpen`, mirror of
`isLocalizedModule_secResₗ_moduleKSheaf`; then `IsLocalizedModule.of_linearEquiv`-style
composition across the opens-equality `V ⊓ D(h i) = D(h i)`), and
`F(D(h i)) ≃ Γ(D(h i))` (trivialization) is free rank 1. Then:

- `Module.Finite Γ(V) F(V)`: `Module.Finite.of_localizationSpan_finite'`
  (mathlib `RingTheory/Localization/Finiteness.lean:191`, worksheet-pinned);
- `Module.FinitePresentation Γ(V) F(V)`:
  `Module.FinitePresentation.of_localizationSpan'`
  (`RingTheory/LocalProperties/FinitePresentation.lean:26`);
- `Module.Flat R F(V)` DIRECTLY over the test ring:
  `Module.flat_of_isLocalized_span` (`RingTheory/Flat/Localization.lean:90`) with
  `Flat R Γ(D(h i))` from `Flat.trans` (localization flat over `Γ(V)`,
  `Γ(V)` `R`-free by `free_relSections` `RigidEngine4Relative.lean:452`);
- `Module.Projective Γ(V) F(V)`: `Module.Flat.projective_of_finitePresentation`
  (`RingTheory/Flat/EquationalCriterion.lean:288`), with `Flat Γ(V) F(V)` again by
  `flat_of_isLocalized_span` at `R := Γ(V)`;
- `Module.Projective R F(V)`: NEW abstract helper (mathlib has no projective-trans):
  `[Module.Free R A] [Module.Projective A P]` + tower `⟹ Module.Projective R P`
  (proof: `Module.projective_def'` split `P →ₗ[A] (P →₀ A)`, restrict scalars,
  `Module.Free.finsupp` + `Module.Projective.of_free` + `Projective.of_split`);
- `Module.Projective R (F(U₀) × F(U₁))`: NEW helper `Module.Projective.prod`
  (split into `(M →₀ R) × (N →₀ R)`, free by `Module.Free.prod`); gives the engine's
  `Flat R (F(U₀) × F(U₁))` via `Module.Flat.of_projective`;
- `AEval'` finiteness of the pair coordinates: NEW abstract helper
  (`moduleFinite_aeval'_of_smul_finite`, the module-over-finite-algebra transitivity):
  `[Algebra R A] [Module A M] [IsScalarTower R A M]`, `a₀ : A`,
  `[Module.Finite R[X] (AEval' (mult-by-a₀ on A))]`, `[Module.Finite A M]`, and
  `e : Module.End R M` with `e m = a₀ • m` `⟹ Module.Finite R[X] (AEval' e)`.
  Applied with `A := Γ(V₀ᴮ)`, `a₀ := relFiberCoord₀` (E-i input:
  `moduleFinite_aeval'_mulSectionEnd_relFiberCoord₀/₁`, `RigidEngine4Relative.lean:408/429`),
  `M := F(V₀ᴮ)` with the `moduleOfLE` structure, `e := pair.t₀`.

All three chart opens (`V₀ᴮ`, `V₁ᴮ`, and the overlap `V₀ᴮ ⊓ V₁ᴮ`) carry trivializing
families: the overlap inherits side-0's family restricted
(`h j ↾_{ovl}`, partition restricts to a partition, pieces `ovl ⊓ D(h j)`
— the overlap interface is instantiated with `V := V₀ᴮ ⊓ V₁ᴮ`,
`h i := h₀ i↾`, using `basicOpen_resHom`). So (D5) delivers every engine hypothesis at
all three opens from ONE abstract lemma set.

## 2. Files and deliverables, staged (commit each stage green)

### Stage (1a) — `Cohomology/GluedSheaf.lean` [≤ 500]
- `Scheme.IsGluingCocycle (U : J → X.Opens) (g : ∀ i j, Γ(X, U i ⊓ U j)ˣ) : Prop` —
  fields `unit_self : ∀ i, (g i i : Γ(X, U i ⊓ U i)) = 1`, `mul_res : ∀ i j l`, the
  cocycle identity in `Γ(X, U i ⊓ U j ⊓ U l)`.
- `gluedSubmodule k U g W : Submodule k (Π j, Γ(X, W ⊓ U j))` + `mem_gluedSubmodule_iff`
  + `gluedSubmodule_res` (restriction stability).
- `gluedRes` (componentwise restriction, `k`-linear) + `@[simp] gluedRes_coe`.
- `gluedPresheaf`, `isSheaf_gluedPresheaf` (TopCat form exposed:
  `isSheaf_gluedPresheaf'` if needed), `gluedSheaf : Sheaf (…) (ModuleCat k)`,
  `@[simp] gluedSheaf_obj`, `secRes_gluedSheaf`.
- **Trivializations**: `gluedTriv (hc : IsGluingCocycle U g) (j) (hW : W ≤ U j) :
  ↥(gluedSubmodule k U g W) ≃ₗ[k] Γ(X, W)` (j-th component; inverse rebuilds the family
  through `g · j`); `gluedTriv_apply`, `gluedTriv_res` (commutes with restriction),
  `gluedTriv_eq_unit_mul` (cross-piece comparison: for `W ≤ U i`, `W ≤ U j`,
  `gluedTriv i = g i j↾_W · gluedTriv j` — the m-chart mirror of `twistTriv₀_inf_eq`).

### Stage (1b) — `Cohomology/GluedSheafQcoh.lean` [≤ 500] + `Cohomology/GluedSheafPair.lean` [≤ ~300]
Qcoh file:
- `AlgebraicGeometry.le_iSup_basicOpen_of_sum_eq_one` (partition ⟹ coverage; stalk/germ
  argument through `Scheme.mem_basicOpen` and the local ring of the stalk).
- componentwise action `gluedQsmul` + (P1) lemma set + `gluedTriv_qsmul` (compat:
  `gluedTriv j (qsmul r m) = r↾ * gluedTriv j m`).
- the two (P2) theorems under the (D3) interface; assembly
  `gluedQcohOn … : Scheme.QcohOn (gluedSheaf k U g) V` (a `noncomputable def`; keyed
  `instance`s only at the pinned datum, Stage 1d-i).
Pair file:
- `gluedPairData` — mirror of `twistPairData` (`RigidEngine4Twist.lean:202`): given
  `r₀ : Γ(X, V₀)`, `r₁ : Γ(X, V₁)`, the two `inf_eq_basicOpen` identities, and
  `r₀↾ · r₁↾ = 1` on the overlap, produce
  `Scheme.TwoCoverPairData (gluedSheaf k U g) V₀ V₁` (componentwise `smul_qsmul`,
  componentwise mutual inverse).

### Stage (1c) — `Cohomology/GluedAlgebra.lean` [≤ ~250] + `Cohomology/GluedSheafModule.lean` [≤ 500]
Algebra file (PURE module algebra, no schemes — D1 discipline; parallel-safe):
- `Module.Projective.prod`;
- `Module.Projective.of_free_algebra` (the (D5) projective-trans over a free algebra);
- `AlgebraicJacobian.RigidEngine.moduleFinite_aeval'_of_smul_finite` (the (D5) AEval'
  transitivity; formulation may take `e_A : Module.End R A` + `he_A : ∀ a, e_A a = a₀ * a`
  to match the landed E-i spelling `Scheme.mulSectionEnd`).
Module file (under the (D3) trivializing-family interface + `[QcohOn F V]` via
`gluedQcohOn`):
- the RE-0 bridge fired per piece: `isLocalizedModule_secResₗ_glued` (unit action via
  trivialization conjugation);
- `moduleFinite_glued : Module.Finite Γ(X,V) F(V)` (via `of_localizationSpan_finite'`;
  span-⊤ from the partition witness: `Ideal.span {h i} = ⊤` since `1 = Σ a·h`);
- `finitePresentation_glued`, `flat_glued : Module.Flat Γ(X,V) F(V)`,
  `projective_glued : Module.Projective Γ(X,V) F(V)`;
- `flat_glued_of_free : Module.Flat R F(V)` and
  `projective_glued_of_free : Module.Projective R F(V)` (both under
  `[Module.Free R Γ(X,V)]` + the scalar-compat hypothesis linking the `R`-action to
  `qsmul ∘ algebraMap`);
- `moduleFinite_aeval'_gluedPair_t₀/t₁` (via `moduleFinite_aeval'_of_smul_finite`).

### Stage (1d-i) — `Cohomology/GluedSheafDatum.lean` [≤ 500] — the pinned datum + the engine
- `Scheme.BasicOpenCocycleDatum C B π` — the §0 structure (fields exactly as pinned).
- `datum.pieces : J₀ ⊕ J₁ → (relCurve C B).Opens`, `datum.gluedSheaf`,
  `instance`s `QcohOn (datum.gluedSheaf) Vᵢᴮ` (from the trivializing families; side-`i`
  family = own side's `h`; the OTHER side's pieces need no basic-open property — the
  interface only requires the covering sub-family to be basic).
- `datum.pairData : TwoCoverPairData … V₀ᴮ V₁ᴮ` at `relFiberCoord₀/₁`
  (`relCover_fiberTwoCover_inf_eq_basicOpen₀/₁`, `relFiberCoord_mul` — all landed).
- **Keystones** (mirrors of `RigidEngine4Engine`, all firing the reused engine):
  - `datumRigidEngine` (fibrewise vanishing ⟹ `H¹(C_B, F) = 0` ∧ `H⁰` finite projective
    over `B`; `[IsNoetherianRing B]` exactly as in the template);
  - `datumRigidEngine_isOpen_vanishing` (Noetherian-free);
  - `datumH0TensorEquiv` (eq:Q, module coefficients);
  - `datumH0BaseChangeEquiv` (ring-map clause, abstract kernel form);
  - `datum_subsingleton_pairH1` (fibre form ⟹ pair form wrapper).

**Sanctioned fallback frontier (worksheet §4)**: (1a)–(1c) + Stage (1d-i) = "the
engine"; the remaining stages may trail.

### Stage (1d-ii) — `Cohomology/GluedSheafBaseChange.lean` — on-the-nose clauses (⚠ balloon #3)
- `BasicOpenCocycleDatum.baseChange` along `B → B'` (push `h`, `a`, units through
  `relSectionsMap`; `Units.map`; partition/cocycle identities by `map_*`; pieces map to
  pieces: `Scheme.preimage_basicOpen`).
- piece-term base change `B' ⊗[B] F(D(h j)) ≃ F'(D(h j'))` (localization commutes with
  base change, through the trivializations and `relTermBaseChange` on the CHART +
  `IsLocalization` away-tensor algebra);
- chart-term base change `B' ⊗[B] F(Vᵢᴮ) ≃ F'(Vᵢᴮ')` — the qcoh-pullback comparison:
  the natural map is an iso because it is one after localizing at each `h j`
  (`bijective`-is-local-on-a-span vocabulary; risk noted: exact mathlib lemma to be
  located, fallback = hand-rolled five-lemma over the finite piece complex);
- twisted δ-naturality square (mirror of `relTwistDiffBaseChange`,
  `RigidEngine4BaseChange.lean:235`) and the two exports
  `datumH0BaseChange` (on the nose) / `datum_subsingleton_h1_baseChange`.
- **The datum base change + these clauses are the RE-5 transport interface (§3.2 of the
  worksheet) and the DAT-3 (a)-step term identifications (§3.1).**

### Stage (1e) — `Cohomology/GluedSheafClass.lean` — the class law
- `BasicOpenCocycleDatum.cechPicClass : (relCurve C B).CechPic` — the class
  `CechPic.mk` of the unit 1-cocycle `g` on the (pointed) cover by the pieces
  (`Picard/Pic.lean:60` vocabulary);
- the glued sheaf of cohomologous data are isomorphic / the class determines the sheaf
  up to the `congrCoeff` transport (`RelativeTwoCover.lean:87` pattern, generalized) —
  exact statement owned by this stage's opening audit against DAT-3's needs;
- naturality in `B`: `(datum.baseChange φ).cechPicClass = CechPic.map … datum.cechPicClass`.

### Stage (1f) — `Cohomology/GluedSheafExtraction.lean` — presentation extraction (§2.3.1)
- every `CechPic` class on `C_B` (`B` affine-test algebra) refines to a
  `BasicOpenCocycleDatum` on finite basic-open families of the two pinned charts:
  qc of `C_B` + the `CechPic` refinement calculus (`CechPic.mk_eq_mk_iff`,
  `Picard/Pic.lean`) + basic-open refinement of an arbitrary open cover of the two
  affine charts (partition witnesses from `Ideal.span`-⊤ on the chart rings).

## 3. Discipline notes specific to this brick
- The Π-indexed components make `Prod.ext`-style proofs into `funext j` + per-component
  `Subtype.ext`; keep every component computation a `resHom`/`map_mul` rewrite, never
  unfold `gluedSubmodule` past `mem_gluedSubmodule_iff`.
- `Scheme.QcohOn.qsmul` head-keyed rewriting (house rule): all action lemmas stated on
  `qsmul`, the `moduleOfLE` instances only ever `letI` inside proofs, never in
  statements (statements use plain `Module.Finite Γ(X,V) …` with a preceding `letI` —
  follow the RE-0 `letI`-in-statement pattern where unavoidable).
- Heartbeat overrides: expected on the (P2) proofs and (1d-ii) square (template
  precedent `RigidEngine4BaseChange.lean:226–230`); use
  `set_option maxHeartbeats/synthInstance.maxHeartbeats` per declaration, restructure on
  KERNEL timeouts (never raise for the kernel).
- Every file: `set_option autoImplicit false`; `backward.isDefEq.respectTransparency
  false` ONLY where relCurve/product spellings mix (Files 1d-i/1d-ii), with the standard
  comment.
- Wire each landed file into `AlgebraicJacobian.lean` (re-read immediately before the
  edit, smallest possible diff); root build green under the mutex before each commit.

## 4. Consumer API map (what downstream calls)
| Consumer | Calls |
|---|---|
| DAT-3 (W6-full) | `gluedSheaf`/`gluedTriv` at field level (its iso `glued(P) ≅ divisorSheaf`), Stage (1d-ii) term identifications at `B → κ(p)`, `TwoCoverPairData.h1Equiv` on `datum.pairData` |
| DAT-C (charts) | `datumRigidEngine_isOpen_vanishing` (the single openness mechanism), `datumH0TensorEquiv`, rank via `h1Equiv` + DAT-3 |
| DAT-B (V-rel-B) | Stage (1f) extraction, `datumRigidEngine`, Stage (1d-ii) transport along `B₀ → B` |
| RE-5 | the §0 datum structure (its descent target), Stage (1d-ii) `datum.baseChange` + on-the-nose clauses |

*End of spec. Binding for the DAT-1 stages; deviations require re-derivation from the
worksheet and a note in the stage commit message.*
