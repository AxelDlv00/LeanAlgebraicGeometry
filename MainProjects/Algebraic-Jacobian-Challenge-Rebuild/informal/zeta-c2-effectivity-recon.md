# (C2) fppf-EFFECTIVITY campaign — reconnaissance (recon half of the worksheet)

*2026-07-14, ζ read-only recon for the (C2)-EFFECTIVITY campaign — the open finish of
"(C2): the plus-construction is a sheaf" (Kleiman `th:cmp` Part 2 recast). This is the
RECON half only: it maps the terrain (statement, staleness, API, gaps, Kleiman, risks).
The route DESIGN is the orchestrator's to write; §3 maps candidate organizations and
their trade-offs but decides nothing. All paths under
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`; Lean paths under `AlgebraicJacobian/`.
Line numbers are as of this checkout (2026-07-14); a prover holds the build lock, so
re-verify keystone shapes with the LSP before proving. READ-ONLY: this file is the only
deliverable.*

Standing header for the Picard tree (every file below):
`variable {k : Type u} [Field k] (C : Over (Spec (.of k)))`; the affine test is
`overSpec k A : Over (Spec (.of k))` = `Spec A → Spec k`. Local notation used throughout
this doc, matching the landed code (`CechKernelLemma.lean:48-78`,
`EtaleSeparatednessClose.lean:77-92`):
- `XA := (C ⊗ overSpec k A).left`, `XB := (C ⊗ overSpec k B).left`,
  `Xq := (C ⊗ overSpec k (B ⊗[A] B)).left` — the **curve products** (curves over the base);
- `SA := (overSpec k A).left = Spec A`, `SB := Spec B`, `Sq := Spec (B ⊗[A] B)` — the
  **affine bases**;
- `pA := (snd C (overSpec k A)).left : XA ⟶ SA`, `pB`, `p₂` — the projections (Kleiman's
  `f_T`);
- `cg := (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left : XA ⟶ XB` —
  **the cover inclusion on the curve product** (base change of `Spec B → Spec A` to the
  curve; Kleiman's `p_X : X_{T'} → X_T`). THIS is the "cg" of the mission.
- `u₁ := (C ◁ overSpecMap tensorInl).left`, `u₂ := (C ◁ overSpecMap tensorInr).left :
  XB ⟶ Xq` — the two coprojection inclusions on the curve product, from
  `tensorInl, tensorInr : B →ₐ[A] B ⊗[A] B`.

---

## §0. The precise remaining statement, in the project's own types

### 0.1 The top-level deliverable (unchanged from the original recon §1.3)

```lean
theorem PicEtAff.unit_surjective_of_section
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (A : Type u) [CommRing A] [Algebra k A] (σ : overSpec k A ⟶ C) :
    Function.Surjective (PicEtAff.unit C A)
```
plus `PicEtAff.unitEquiv_of_section := MulEquiv.ofBijective ⟨unit_injective, unit_surjective_of_section⟩`.
With the landed unconditional (C1) `PicEtAff.unit_injective` (`CechKernelLemma.lean:361`)
this yields the iso `relPic C (overSpec k A) ≃* PicEtAff C A` over section-admitting tests.
The section is a **theorem hypothesis** `σ : overSpec k A ⟶ C` (a curve `T`-point), never a
`HasRationalPoint` class — the frozen `Curve` (`Challenge.lean:67`) carries no point. This
target is confirmed by the landed `Picard/PicEtUnit.lean:34` docstring and the correction
record; it has **not** changed.

### 0.2 The reduction to effectivity — LANDED-adjacent, LA, delegable

`unit_surjective_of_section` reduces to a single fppf-descent brick by an EXACT MIRROR of
the landed (C1) unfold `PicEtAff.unit_injective_of_ker` (`EtaleSeparatednessClose.lean:193`),
running the rigidification keystones that already landed. Given `q : PicEtAff C A`, write
`q = mk C E x` (`PicEtAff.ind`), `E : Algebra.EtaleCover A`, `x ∈ descentClasses C E`,
`B := E.Carrier` (an étale cover carries `[Module.FaithfullyFlat A B]` for free,
`EtaleCover.lean:86`). Then:

1. `σ_B := Over.overSpecMap ((Algebra.ofId A B).restrictScalars k) ≫ σ` — the section
   base-changed to `B` (`sectionOfPoint_naturality`, `Rigidification.lean:99`).
2. **G1 landed** — `relPic.exists_isRigidified_rep σ_B (↑x)` (`Rigidification.lean:190`)
   gives `L : XB.CechPic` with `Over.IsRigidified σ_B L` and `relPicMk C _ L = ↑x`.
3. **Keystone landed** — since `relPicMk C _ L = ↑x ∈ descentClasses C E`,
   `Over.IsRigidified.cechPicMap_doubleInl_eq_doubleInr σ … hmem hrig`
   (`Rigidification.lean:278`) gives the **on-the-nose Čech-Picard descent equation**
   `u₁^* L = u₂^* L` in `Xq.CechPic` (via `doubleInl/doubleInr = includeLeft/includeRight`).
4. **THE GAP (§0.3)** — effectivity: `∃ M : XA.CechPic, cg^* M = L`.
5. Close: set `λ := relPicMk C (overSpec k A) M`. Then `unit C A λ = mk C E x` by
   `PicEtAff.unit_eq_mk C E λ` (`RelPicCoverInjective.lean:48`) + `relPicMap_mk`
   (`RelPic.lean:111`) + `cg^* M = L` + `relPicMk C _ L = ↑x`, using proof-irrelevance of the
   `descentClasses` membership (`Subtype.ext`). This step is pure `relPicMk`/`mk`-calculus.

Everything except step 4 is landed machinery or a one-screen mirror of the (C1) unfold.
**The entire new mathematical content of (C2) is step 4.**

### 0.3 The gap, stated against landed declarations — the (C2) EFFECTIVITY lemma

The dual of the landed (C1) kernel lemma
`Over.exists_cechPic_map_snd_of_ker_whiskerLeft` (`CechKernelLemma.lean:259`,
`ker(cg^*) ⊆ range(pA^*)`). What must be produced (name/shape indicative — the orchestrator
fixes it):

```lean
theorem Over.exists_cechPic_map_whiskerLeft_eq       -- (C2) EFFECTIVITY (the campaign)
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    {A B : Type u} [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
    [Algebra A B] [IsScalarTower k A B] [Module.FaithfullyFlat A B]
    (σ : overSpec k A ⟶ C)                                   -- the section (curve A-point)
    (L : XB.CechPic)
    (hrig : Over.IsRigidified                                -- L rigidified along σ_B
      (Over.overSpecMap ((Algebra.ofId A B).restrictScalars k) ≫ σ) L)
    (hdesc : CechPic.map u₁ L = CechPic.map u₂ L) :          -- on-the-nose descent eq on Xq
    ∃ M : XA.CechPic, CechPic.map cg M = L
```

This is Kleiman's Part-2 core "`(L',u')` descends to `(L,u)` on `X_T`" recast on the
cocycle model: a rigidified invertible sheaf `L` on the curve over the cover `SB`, whose
two pullbacks to the curve over the double base `Sq` are equal **as classes**, descends
along the faithfully-flat cover inclusion `cg` to a sheaf on the curve over `SA`.

**Why the section is genuinely needed here (a load-bearing terrain finding).** `hdesc` is
an equality of *isomorphism classes* in `Xq.CechPic` — it gives the *existence* of a
comparison isomorphism `φ : u₁^*L ≅ u₂^*L`, NOT a canonical one. Descending an invertible
sheaf needs a chosen `φ` satisfying the cocycle condition on the triple curve product
`X_{B⊗B⊗B}`; the triple-overlap automorphism `φ₁₃⁻¹φ₂₃φ₁₂` obstructs it. Kleiman kills that
automorphism with `lm:aut` (needs the section) — landed here as **G2**
`Over.unitsAppTop_sectionOfPoint_bijective` (`Rigidification.lean:333`). This is exactly
why (C1)/Part 1 needs no section and (C2)/Part 2 does: in (C1) the class is *trivial on the
cover*, so a genuine trivializing cochain `β` exists and its comparison unit's cocycle is
free (telescope cancels, no section); in (C2) the class is nontrivial on the cover, only
`hdesc` (a class equation) is available, and the section is what pins the cochain-level
cobounding. **So the effectivity brick consumes `σ` (via G2), not merely the FF cover** —
the "σ-normalized cobounding" of the correction record.

---

## §1. Staleness audit

### 1.1 What of the original recon (`zeta-c2-rigidification-recon.md`) survives

The original recon's §1 (statement, section-as-hypothesis, rational-point vocabulary), §2
(API map), and §4/§5 (brick shape, sequencing) are **correct and survive**. Its **§3 gap
list is partly stale**:

- **G0 (section↔point bridge)** — LANDED as `Over.sectionOfPoint` (`Rigidification.lean:85`)
  with `sectionOfPoint_fst/snd`, `sectionOfPoint_naturality`, and the retraction
  `cechPicMap_sectionOfPoint_snd`. ✅
- **G1 (`lm:idn` surjectivity)** — LANDED as `relPic.exists_isRigidified_rep`
  (`Rigidification.lean:190`), plus `lm:idn` injectivity `IsRigidified.eq_of_relPicMk_eq`
  (:154) and the rigidified transport keystone `IsRigidified.cechPicMap_congr` (:242) /
  `…_doubleInl_eq_doubleInr` (:278). ✅ (More than the original G1 asked.)
- **G2 (`lm:aut` ring heart)** — LANDED as `Over.isIso_appTop_sectionOfPoint` (:314) and
  `Over.unitsAppTop_sectionOfPoint_bijective` (:333). ✅
- **G3 (the "surjectivity core, one-shot descent to Pic A")** — **WRONG and RETRACTED.**
  The implementing agent found the recon's route — "descend to `M : Pic A` via
  `cechPicEquivPic`, transport to `relPic C A`, prove `unit λ = mk C E x`" — produces
  classes that are **trivial in `relPic`** (they lie in `picFromBase`, the pulled-back-from-
  base subgroup that `relPic` quotients out). The honest remaining content is the fppf
  effectivity of §0.3 — **campaign-scale**, a mirror of the (C1) ζ2/ζ3 close, NOT one lemma.
  This recon replaces §3-G3.
- **G4 (Layer-2 unit `picEtUnit`)** — LANDED IN FULL as `picEtUnit : relPicFunctor C ⟶
  picEtFunctor C` (`PicEtUnit.lean:231`), with `relPicToPicEt` (:126), affine consistency
  `picEtAffineEquiv_relPicToPicEt` (:161), naturality `picEtMap_relPicToPicEt` (:194), and
  the `fromSpecAffine` plumbing (:60-116). The degree/Pic⁰ interface is now UNBLOCKED on
  this shared prerequisite. ✅
- **G5 (global/functorial (C2))** — still open, still optional; depends on the effectivity
  campaign + G4. Unchanged.

### 1.2 What the first wave landed vs. left

**Landed** (commit `8cd9ab33f`, `Picard/Rigidification.lean` + `Picard/PicEtUnit.lean`,
10 keystones axiom-clean, root build 8659 jobs): G0, G1 both directions, the UNCONDITIONAL
on-the-nose rigidified descent equation (the entry point of the campaign), G2, and G4
(`picEtUnit`) in full. **Left**: the effectivity brick of §0.3 and the §0.2 reduction to it
(the surjectivity statement itself), plus optional G5.

### 1.3 What changed in the tree since the original recon

- `Picard/Rigidification.lean` (new, 366 lines) and `Picard/PicEtUnit.lean` (new, 254
  lines) landed — the G0-G2 + G4 wave. Both import into the tree; not yet wired to a
  surjectivity theorem.
- The (C1) campaign is CLOSED and is the mirror template: `PicEtAff.unit_injective`
  (`CechKernelLemma.lean:361`), its kernel lemma (`:259`), unfold
  (`EtaleSeparatednessClose.lean:193`), and the entire ζ2/ζ3 machinery (§2b) are landed and
  axiom-clean.
- The χ-ledger (Wave-2b) advanced independently (G7 closed, G8/G9 frontier — irrelevant to
  (C2) except that it and (C2) share nothing but G4). No (C2)-relevant regressions.
- No existing `unit_surjective`/`unitEquiv_of_section`/`effectivity` declaration in the
  tree (grep clean) — the campaign starts from the landed rigidification layer.

---

## §2. Verbatim API map of everything the campaign consumes

### 2a. The rigidification layer's exact keystones (the campaign's INPUT — `Rigidification.lean`)

```lean
-- G0: the section and its retraction
noncomputable def Over.sectionOfPoint (σ : T ⟶ C) : T ⟶ C ⊗ T := lift σ (𝟙 T)          -- :85
@[simp] lemma sectionOfPoint_fst : sectionOfPoint σ ≫ fst C T = σ                        -- :89
@[simp] lemma sectionOfPoint_snd : sectionOfPoint σ ≫ snd C T = 𝟙 T                      -- :93
lemma sectionOfPoint_naturality (g : T' ⟶ T) (σ) :                                       -- :99
    g ≫ sectionOfPoint σ = sectionOfPoint (g ≫ σ) ≫ (C ◁ g)
lemma Over.cechPicMap_sectionOfPoint_snd (σ) (N : T.left.CechPic) :                       -- :110  ★ retraction
    CechPic.map (sectionOfPoint σ).left (CechPic.map (snd C T).left N) = N
-- rigidified classes (a Prop, no stored data)
def Over.IsRigidified (σ : T ⟶ C) (L : (C ⊗ T).left.CechPic) : Prop :=                    -- :128
    CechPic.map (sectionOfPoint σ).left L = 1
theorem IsRigidified.cechPicMap (g : T' ⟶ T) (hL : IsRigidified σ L) :                    -- :142  base-change stability
    IsRigidified (g ≫ σ) (CechPic.map (C ◁ g).left L)
theorem IsRigidified.eq_of_relPicMk_eq (hL hL') (h : relPicMk C T L = relPicMk C T L') :  -- :154  ★ lm:idn injective
    L = L'
theorem IsRigidified.eq_one_of_relPicMk_eq_one (hL) (h : relPicMk C T L = 1) : L = 1      -- :171
-- G1: lm:idn surjective
theorem relPic.exists_isRigidified_rep (σ : T ⟶ C) (x : relPic C T) :                     -- :190  ★ G1
    ∃ L, Over.IsRigidified σ L ∧ relPicMk C T L = x
-- the rigidified transport keystones (the campaign ENTRY POINT)
theorem Over.IsRigidified.cechPicMap_congr (j₁ j₂ : E.Carrier →ₐ[A] R) (σ) (hmem hrig) :  -- :242  ★
    CechPic.map (C ◁ overSpecMap (j₁.restrictScalars k)).left L
      = CechPic.map (C ◁ overSpecMap (j₂.restrictScalars k)).left L
theorem Over.IsRigidified.cechPicMap_doubleInl_eq_doubleInr (σ) (hmem hrig) :             -- :278  ★★ feeds §0.3 hdesc
    CechPic.map (C ◁ overSpecMap (doubleInl E)).left L
      = CechPic.map (C ◁ overSpecMap (doubleInr E)).left L
-- G2: lm:aut ring heart  [needs IsProper + GeometricallyIrreducible + GeometricallyReduced]
theorem Over.isIso_appTop_sectionOfPoint (σ : overSpec k A ⟶ C) :                         -- :314
    IsIso ((sectionOfPoint σ).left.appTop)
theorem Over.unitsAppTop_sectionOfPoint_bijective (σ : overSpec k A ⟶ C) :                -- :333  ★ G2 (σ-normalization)
    Function.Bijective ((sectionOfPoint σ).left.unitsAppLE ⊤ ⊤ …)
```
`IsRigidified.cechPicMap_doubleInl_eq_doubleInr` is the single input the effectivity brick
consumes from this layer (as `hdesc`); `unitsAppTop_sectionOfPoint_bijective` is the G2
tool the "σ-normalized cobounding" uses. `IsRigidified.cechPicMap` propagates
rigidification along test morphisms (needed to rigidify pieces).

### 2b. The (C1) campaign machinery reusable here (each with its (C1) role)

**Brick 3 — projection injectivity (the `lm:aut` cochain workhorse).**
```lean
theorem Over.prPullback_injective : Function.Injective (Scheme.CechPic.map (snd C T).left)  -- Separatedness.lean:269
theorem Over.isIso_appLE_snd (hV : IsAffineOpen V) : IsIso ((snd C T).left.appLE …)          -- Separatedness.lean:87
theorem Over.unitsAppLE_snd_bijective (hV) : Function.Bijective (unitsAppLE …)              -- Separatedness.lean:153
theorem Over.appLE_snd_injective (W) : Function.Injective (appLE …)                          -- Separatedness.lean:125
```
(C1) role: injectivity of projection pullback on Čech-Picard classes/units — the
class-level `lm:aut`. (C2) role: the same, plus the affine-open form `isIso_appLE_snd`
provides the per-piece section-pullback isos on `cg`-saturated pieces.

**ε1 — projection-descent equivalence for unit sections (`ProjectionUnits.lean`).**
```lean
noncomputable def Over.unitsSndEquiv (hV : IsAffineOpen V) :                                 -- :81  ★
    Γ(T.left, V)ˣ ≃* Γ((C ⊗ T).left, (snd C T).left ⁻¹ᵁ V)ˣ
theorem unitsSndEquiv_symm_eq_of_unitsAppLE …                                                -- :122  uniqueness
theorem unitsSndEquiv_unitsRestrict … / _symm_unitsRestrict …                                -- :133/:144  restriction naturality
theorem Over.snd_left_naturality (g : T' ⟶ T) :                                             -- :166  ★ the base square
    (C ◁ g).left ≫ (snd C T).left = (snd C T').left ≫ g.left
theorem unitsSndEquiv_naturality (g : T' ⟶ T) (hV) …                                         -- :191  test-object naturality
```
(C1) role: descend global/affine-open units from the curve product to the base; every
coherence check pushed through this equiv. (C2) role: descend the σ-normalized cobounding
units on each `cg`-saturated affine piece; `snd_left_naturality` is the base square that
relates `cg`, `pA`, `pB` (already used in the (C1) `hcomp`, `EtaleSeparatednessClose.lean:163`).

**ε2 — descent-in-stages / cocycle collapse (`Descent/UnitDescentComposite.lean`).**
```lean
noncomputable def tensorCollapse : P ⊗[A] P →ₐ[A] P ⊗[B] P                                   -- :61
theorem IsDescentCocycle.collapse (hv : IsDescentCocycle v) : IsDescentCocycle (Units.map …) -- :94
theorem descended_le_descended_collapse …                                                    -- :140
noncomputable def descendedCollapseEquiv (hv) : B ⊗[A] descended v ≃ₗ[B] descended (collapse v)  -- :163
theorem IsDescentCocycle.picClass_collapse (hv) :                                            -- :206
    (collapse v).picClass = Pic.mapAlgebra A B v.picClass
```
(C1) role: relate a composite-cover `A`-descent cocycle to the Zariski `B`-cover cocycle;
supplied the class equation `Pic.mapAlgebra A B (picClass v) = picClass u`. (C2) role:
possibly reused if the effectivity is organized through a composite descent unit rather than
per-piece; less certain to be needed on the per-piece route.

**Amitsur toolkit — global-unit gluing + cofaces (`AmitsurCochain.lean`).**
```lean
theorem exists_global_unit_of_compatible (β) (…∂β = 1…) : ∃ w : Γ(X,⊤)ˣ, …                   -- :65  (P1) glue
theorem global_unit_ext (w w') (…agree on members…) : w = w'                                 -- :79  (P1) separate
def tensorFace₁₂/₁₃/₂₃ : B ⊗[A] B →ₐ[k] B ⊗[A] (B ⊗[A] B)                                    -- :105/:110/:115  cofaces
lemma tensorFace₁₂_comp_tensorInl … (simplicial identities)                                  -- :122-136
noncomputable def unitsSndTopEquiv (R) : (B-side global-unit ⊤-descent)                       -- :153  (P2b)
theorem appTop_units_surjective / _injective (R)                                             -- :169/:178  (P2b)
theorem unitsSndTopEquiv_naturality (φ : R →ₐ[k] R') …                                        -- :190
```
(C1) role: ζ2·P — `𝒪ˣ`-sheaf gluing of a compatible unit 0-cochain into a global unit, and
the coface calculus that makes the Amitsur telescopes cancel. (C2) role: the same gluing +
coface calculus underpin any cochain-level cobounding + triple-product cocycle check.

**ζ2·i coherent witness (`CoherentWitness.lean`, `CoherentWitnessExists.lean`).**
```lean
structure CoherentCechWitness (𝒩) (γ) : …                                                    -- CoherentWitness.lean:255
    (a refining cover + unit 0-cochain θ whose ∂θ compares the two pullbacks of γ,
     and whose three coface pullbacks satisfy the Amitsur cocycle relation)
noncomputable def amitsurCover …                                                             -- :234
theorem Scheme.Hom.unitsAppLE_coboundary_rel …                                               -- :93  ★ pullback of a coboundary
theorem Over.exists_coherentCechWitness (…ζ1 hyp p_B^*N = cg^*L…) :                          -- CoherentWitnessExists.lean:345 ★
    Nonempty (CoherentCechWitness k A B 𝒩 γ)
theorem Over.glued_defect_eq_amitsur_coboundary …                                            -- :291
```
(C1) role: from a class equation `q₁^*N = q₂^*N` over `Sq`, produce a Čech witness that is
Amitsur-COHERENT over the triple `S_{B⊗B⊗B}` — the "global-unit correction". **This is the
closest structural analogue of the (C2) obstruction**: turning a *class* equation into a
*coherent cochain*. (C2)'s "σ-normalized cobounding" is the mirror where the coherence comes
from the section (G2) instead of from an upstairs trivialization.

**ζ2·ii pi-assembly (`WitnessAssembly.lean`).**
```lean
noncomputable def Over.assemblyUnit (θ') (P) : (Pi ⊗[A] Pi)ˣ                                  -- :129
theorem Over.isDescentCocycle_assemblyUnit : Module.IsDescentCocycle (assemblyUnit θ' P)     -- :171  ★
theorem Over.tensorCollapse_assemblyUnit …                                                    -- :187
theorem Over.mapAlgebra_picClass_assemblyUnit [FF A B] :                                      -- :238  ★ class equation to ζ3
    Pic.mapAlgebra A B (assemblyUnit θ' P).picClass = P.pic γ
noncomputable def Over.witnessComponent (θ') (P) (i j) : (S i ⊗[A] S j)ˣ                      -- :111
theorem Over.sectionsTopAlgEquiv : Γ(XB,⊤) ≃ₐ[A] B ;  faithfullyFlat_sectionsTop             -- :216/:228
```
(C1) role: assemble the coherent witness's glued components into a genuine composite
`A`-descent cocycle `v` on `Pi = ∏ S_i` and hand ζ3 the class equation. (C2) role: the
per-piece descent datum will be a `Module.IsDescentCocycle` on the affine piece's ring; this
is the template for building one from cochain components. `sectionsTopAlgEquiv` (`Γ(XB,⊤) ≃ₐ B`)
is `Over.universalSections` re-exported and is the affine-base version of the piece rings.

**ζ3 bricks (the kernel-lemma internals — the direct mirror of the effectivity brick).**
```lean
theorem Over.exists_kernelDescentUnit …    -- KernelDescentUnit.lean:407  (brick W: class→descent unit)
noncomputable def Over.descentClassRep …   -- DescentClassRepBuild.lean:490 (brick M: descended class→cover/cocycle/μ)
noncomputable def Over.gluePiece …         -- CechKernelGlue.lean:154      (brick G: local cobounding pieces)
theorem Over.exists_kernelCobounding [FF] … -- CechKernelGlue.lean:443     (brick G: glue+descend the pieces via cg)
theorem Over.exists_cechPic_map_snd_of_ker_whiskerLeft [proper+gi+gr][FF] :  -- CechKernelLemma.lean:259 ★★ THE MIRROR
    (E : XA.CechPic) (hE : CechPic.map cg E = 1) → ∃ M₁ : SA.CechPic, CechPic.map pA M₁ = E
theorem Over.exists_cechPic_map_snd_eq_of_ker … -- EtaleSeparatednessClose.lean:115 (reduction using the kernel prop)
theorem PicEtAff.unit_injective_of_ker …        -- EtaleSeparatednessClose.lean:193 (the unfold §0.2 mirrors)
```
(C1) role: the whole `ker(cg^*) ⊆ range(pA^*)` engine. (C2) role: **`…of_ker_whiskerLeft`
is the exact statement whose DUAL is §0.3.** The (C2) effectivity should be organized as a
sibling file/lemma family to these — same `cg`/`pA`/`unitsAppLE`/`gluePiece` vocabulary,
opposite direction (build `M` with `cg^*M = L` from `hdesc`, not `M₁` with `pA^*M₁ = E` from
`cg^*E = 1`).

**Brick 4 — module/flat descent (`Descent/ModuleDescent.lean`, `InvertibleModule.lean`,
`UnitDescent.lean`).**
```lean
structure Module.DescentDatum A B M (coaction, counit, coassoc)                               -- ModuleDescent.lean:124
theorem DescentDatum.comparison_bijective [Flat A B] : Bijective D.comparison                 -- :208  (effectivity)
noncomputable def DescentDatum.descentEquiv [Flat] : B ⊗[A] descended ≃ₗ[B] M                 -- :233
noncomputable def DescentDatum.unitEquiv (N) : N ≃ₗ[A] (baseChange A B N).descended           -- :269  (uniqueness)
noncomputable def DescentDatum.equivDescended (e : B ⊗[A] N ≃ₗ[B] M) …                         -- :292
theorem Invertible.of_invertible_tensorProduct_of_faithfullyFlat (P) [FF][Invertible B (B⊗P)] -- InvertibleModule.lean:229 ★
    : Module.Invertible A P
structure Module.IsDescentCocycle (u : (B ⊗[A] B)ˣ) (lmul'_eq_one, cocycle)                    -- UnitDescent.lean:91  ★ the Čech form
noncomputable def IsDescentCocycle.descended (hu) : Submodule A B                              -- :181
noncomputable def DescentDatum.ofUnit (hu : IsDescentCocycle u) : DescentDatum A B B           -- :164
instance IsDescentCocycle.invertible_descended [FF] : Module.Invertible A hu.descended         -- :197
noncomputable def IsDescentCocycle.picClass [FF] (hu) : CommRing.Pic A                          -- :203  ★
```
(C1) role: a Čech unit cocycle `u ∈ (B⊗[A]B)ˣ` (via a `BasicRefinement`) descends to an
invertible `A`-module and yields a `Pic A` class. (C2) role: on each `cg`-saturated affine
piece `V` of `XA` with piece ring `R_V := Γ(V)` and cover ring `Γ(cg⁻¹V) = R_V ⊗_A B`
(faithfully flat over `R_V`), the σ-normalized comparison is exactly a
`Module.IsDescentCocycle`, and `picClass`/`invertible_descended` descend the piece.

**Affine Čech↔ring dictionary + basic refinements (`CechPicSurjective.lean`,
`CechPicToPicNaturality.lean`, `PicAffineCover.lean`, `PicAffine.lean`).**
```lean
noncomputable def Scheme.cechPicEquivPic (X) [IsAffine X] : X.CechPic ≃* CommRing.Pic Γ(X,⊤)   -- CechPicSurjective.lean:283 ★
theorem Scheme.CechPic.toPic_map / toPic_mapAlgebra …                                          -- CechPicToPicNaturality.lean  (naturality)
structure Scheme.PointedCover.BasicRefinement (𝒰) …                                            -- PicAffineCover.lean:53
theorem BasicRefinement.nonempty [IsAffine X] (𝒰) : Nonempty 𝒰.BasicRefinement                -- :75
theorem BasicRefinement.span_eq_top [IsAffine X] : Ideal.span (Set.range P.r) = ⊤             -- :266
theorem BasicRefinement.faithfullyFlat [IsAffine X] : Module.FaithfullyFlat Γ(X,⊤) (∏ …)      -- :273
noncomputable def BasicRefinement.pic [IsAffine] (γ) : CommRing.Pic Γ(X,⊤)                     -- :280
lemma BasicRefinement.pic_eq_picClass (γ) : P.pic γ = (P.isCoverCocycle γ).picClass            -- :290 ★ bridge cover-cocycle↔module-cocycle
theorem BasicRefinement.pic_congr / pic_eq_of_isCohomologous / class_eq_one_of_pic_eq_one      -- PicAffine.lean:339/109/393
```
(C1) role: `cechPicEquivPic` is the affine dictionary the whole close routes through;
`BasicRefinement` turns a Čech unit cocycle on an affine scheme into a module descent
cocycle. (C2) role: `cechPicEquivPic` applies to each **affine** piece `V` of `XA` (NOT to
`XB` — `XB` is a curve, not affine; this is precisely the point that broke the recon's G3);
`BasicRefinement` builds the per-piece module cocycle.

**Reassembly toolkit — clopen partitions & finite-product/Zariski gluing.**
```lean
theorem CechPic.eq_of_map_eq_of_clopen …                                                       -- CechPicClopenSep.lean:188
theorem exists_map_eq_of_clopen [Finite ι] …                                                   -- CechPicClopenGlue.lean:312
noncomputable def extendClass / extCover / extCocycle …                                        -- CechPicClopenGlue.lean:226/67/221
theorem relPic.eq_of_pi_proj_eq [Finite ι] {ζ ζ'} … / relPic.exists_pi_lift [Finite ι] …       -- RelPicPi.lean:297/342
theorem PicEtAff.eq_of_away_eq (hg : span (range g) = ⊤) … / exists_mapAlg_eq_of_compat …       -- PicEtAffZariskiSep.lean:137 / Glue.lean:337
theorem relPicAlgMap_algEquiv_injective (e : A ≃ₐ B) … / mapAlg_mk_eq_mk …                      -- Glue.lean:274/287
```
(C1)/Layer-2 role: glue Picard classes across a finite-product (field) cover or a Zariski
`away` cover of the base `Spec A`. (C2) role: candidate machinery for the "basic-refinement
reassembly" of §3-E — but note these glue classes on the AFFINE BASE (`Spec A`, `∏ B_i`),
whereas the (C2) reassembly must glue local classes on affine OPENS of the CURVE `XA`. See
§3-E and §5 for the gap.

### 2c. The plus-construction consumer shapes (what §0.2 unfolds against)

```lean
def descentClasses (E) : Subgroup (relPic C (overSpec k E.Carrier))                            -- PicEtAff.lean:76
   := MonoidHom.eqLocus (relPicAlgMap C (doubleInl E)) (relPicAlgMap C (doubleInr E))
def doubleInl E : E.Carrier →ₐ[k] E.Carrier ⊗[A] E.Carrier := TensorProduct.includeLeft        -- :64
def doubleInr E := (TensorProduct.includeRight).restrictScalars k                              -- :69
def PicEtAff.mk (E) (x : descentClasses C E) : PicEtAff C A                                     -- :224
theorem PicEtAff.ind …                                                                          -- :227
theorem PicEtAff.mk_eq_mk_iff … : mk C E x = mk C F y ↔ ∃ G f g, descentMap C f x = descentMap C g y  -- :235
theorem relPicAlgMap_congr (j₁ j₂ : E.Carrier →ₐ[A] R) (hx ∈ descentClasses) : …               -- :161  keystone behind Rigidification.lean:242
def PicEtAff.unit (A) : relPic C (overSpec k A) →* PicEtAff C A                                 -- :377
theorem PicEtAff.unit_eq_mk (E) (z) : unit C R z = mk C E ⟨relPicAlgMap C (ofId R E.Carrier) z, …⟩  -- RelPicCoverInjective.lean:48 ★ (close step)
theorem relPicAlgMap_injective_of_etaleCover (E) : Injective (relPicAlgMap C (ofId R E.Carrier))    -- :81  [proper+gi+gr]
-- source functor plumbing:
def relPicMk (T) : (C ⊗ T).left.CechPic →* relPic C T ;  relPicMk_surjective ;  relPicMk_eq_relPicMk_iff  -- RelPic.lean:70/74/80
lemma relPicMap_mk (g) (L) : relPicMap C g (relPicMk C T L) = relPicMk C T' (CechPic.map (C ◁ g).left L)  -- RelPic.lean:111 ★
def picFromBase (T) := (CechPic.map (snd C T).left).range ; mem_picFromBase_iff                 -- RelPic.lean:54/57
noncomputable def relPicAlgMap (f : A →ₐ[k] B) := relPicMap C (overSpecMap f) ; relPicAlgMap_comp  -- RelPicAlgebra.lean:88/98
-- Layer-2 unit (landed G4), the eventual global consumer:
def picEtUnit : relPicFunctor C ⟶ picEtFunctor C ; picEtAffineEquiv_relPicToPicEt              -- PicEtUnit.lean:231 / :161
```

### 2d. "cg" — the cover inclusion on the curve product, and every landed lemma about it

`cg := (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left : XA ⟶ XB`. It is
the base change of the affine cover map `gS := (overSpecMap (ofId A B)).left : SA ⟶ SB`
(`Spec B → Spec A`) along the curve, so `cg` is affine and faithfully flat (from
`[Module.FaithfullyFlat A B]`). Landed facts (all in the (C1) close, reusable verbatim):

- **Base square**: `Over.snd_left_naturality C (overSpecMap (ofId A B))` gives
  `cg ≫ pB = pA ≫ gS` (as `.left` morphisms) — `ProjectionUnits.lean:166`, used at
  `EtaleSeparatednessClose.lean:163` (`hcomp`) and `CechKernelLemma.lean:216` (`cg_comp_pA`).
- **Preimage/cover pullback calculus**: `(cg).preimage_mono`, `(cg).le_preimage_inf`,
  `ℰ.pullback cg` (pulling a `PointedCover` of `XA` back to `XB`), `preimage_le_pB_gS`,
  `cg_comp_pA` — all exercised throughout `CechKernelLemma.lean`, `CechKernelGlue.lean`.
- **Injectivity of `cg`-pullback on units**: `Over.appLE_whiskerLeft_injective`
  (`CechKernelLemma.lean:137`) — units on `XB` are separated by pullback? NO: this is
  injectivity of `cg^#` used in the kernel `hinj`; the (C2) effectivity uses the same to
  verify its cobounding relations after `cg`-pullback.
- **`cg^*` on Čech-Picard**: `CechPic.map cg : XA.CechPic →* XB.CechPic` with
  `CechPic.map_comp`, `map_mk`, `pullbackUnitsH1_class`, `mk_eq_one_iff` — the whole
  `CechKernelLemma.lean` mk-calculus. The effectivity's conclusion `cg^* M = L` lives here.
- The doubled version `u₁ = C ◁ overSpecMap tensorInl`, `u₂ = C ◁ overSpecMap tensorInr`
  (`CechKernelLemma.lean:58-60`) is what `hdesc` is stated with; `tensorInl/tensorInr :
  B →ₐ[k] B ⊗[A] B` from `EtaleSeparatedness.lean:87/93`.

No lemma named "cg" exists as a standalone `def` — it is a `local notation` in each file
(`CechKernelLemma.lean:55`, `EtaleSeparatednessClose.lean:87`,
`CoherentWitnessExists.lean:95`, `KernelDescentUnit.lean:112`). The campaign will re-declare
the same notation.

---

## §3. Gap list in dependency order

Legend: **[LA]** linear-algebra / pure-algebra / cochain-calculus (delegable to a prover
once specced); **[GEO]** scheme-geometry (curve-product opens, affineness, base squares);
**[MIX]** both. "(C1) mirror" = the landed declaration this gap dualizes.

Route-A components below are the correction record's suggested route (cg-saturated affine
pieces → σ-normalized cobounding → per-piece descent → basic-refinement reassembly). Route-B
is an alternative (direct global descent unit, closer to the (C1) close). The recon does
NOT choose; §5 flags where each could balloon.

### The reduction (both routes)

- **R0 — the surjectivity reduction. [LA, delegable].** `§0.2`: `unit_surjective_of_section`
  + `unitEquiv_of_section` from the effectivity brick, running G1 + the rigidified keystone
  + `unit_eq_mk`/`mk_eq_mk_iff`. **(C1) mirror:** `PicEtAff.unit_injective_of_ker`
  (`EtaleSeparatednessClose.lean:193`) + `unit_injective` (`CechKernelLemma.lean:361`). A
  one-screen dual; write it LAST once the effectivity name is final. Low risk.

### Route A — cg-saturated affine pieces (the correction record's route)

- **A1 — cg-saturated affine cover of the curve product. [GEO].** Cover `XA` by affine
  opens `V` with `cg⁻¹V` affine and `cg|_{cg⁻¹V} : cg⁻¹V → V` the base change of `A → B`
  (so `Γ(cg⁻¹V) ≅ Γ(V) ⊗_A B`, faithfully flat over `Γ(V)`). `cg` is affine (base change of
  the affine `gS`), so `cg`-preimages of affine opens are affine; the affine opens of `XA`
  form a basis (used at `CechKernelLemma.lean:277`, `isBasis_affineOpens`). **(C1) mirror:**
  the `haff`/`choose Uof` affine refinement of the kernel lemma
  (`CechKernelLemma.lean:274-282`). New content: identifying `Γ(cg⁻¹V) ≅ Γ(V) ⊗_A B` and its
  faithful flatness. Medium risk (the ring identification of the base-changed section ring;
  cf. `WitnessAssembly.lean`'s `isLocalization_away_sections`/`sectionsTopAlgEquiv` for the
  `⊤` case).

- **A2 — σ-normalized comparison cochain on the double curve product. [MIX].** From `hdesc`
  (`u₁^*L = u₂^*L` in `Xq.CechPic`), extract a unit-cochain comparison `φ` on a cover of
  `Xq` (mk-calculus, `class_eq_one_of_pic_eq_one`/`mk_eq_one_iff`), then **σ-normalize** it
  so that its pullback along the section over `Sq` is `1` — using G2
  `unitsAppTop_sectionOfPoint_bijective` and `IsRigidified.cechPicMap` to pin the choice.
  Verify the triple-product cocycle on `X_{B⊗B⊗B}` (Amitsur cofaces
  `tensorFace₁₂/₁₃/₂₃`, `AmitsurCochain.lean`). **(C1) mirror:** `exists_coherentCechWitness`
  (`CoherentWitnessExists.lean:345`) — turning a class equation into a coherent cochain.
  **This is the Fable-grade heart** (the "one genuinely delicate step"): the (C1) coherence
  came free from an upstairs trivialization; here it must come from the section. HIGH risk.

- **A3 — per-piece descent datum + brick 4. [LA, delegable].** On each piece `V`: the
  restriction `L|cg⁻¹V` is a class in `Γ(cg⁻¹V).Pic`; with the σ-normalized comparison from
  A2 restricted to `V`, build a `Module.IsDescentCocycle` (or `Module.DescentDatum`) over
  `Γ(V)` along `Γ(V) → Γ(V) ⊗_A B`; descend via `IsDescentCocycle.picClass` /
  `Invertible.of_invertible_tensorProduct_of_faithfullyFlat` to a class `M_V ∈ Γ(V).Pic`,
  transported to `V.CechPic` by `cechPicEquivPic` (now legitimate — `V` IS affine).
  **(C1) mirror:** ζ2·ii `assemblyUnit`/`isDescentCocycle_assemblyUnit`/`picClass`
  (`WitnessAssembly.lean:129/171`) + brick 4. Medium risk (mechanical once A2's cochain is
  in hand).

- **A4 — basic-refinement reassembly. [GEO/MIX].** Glue the per-piece `M_V` into a global
  `M : XA.CechPic` with `cg^* M = L`. On overlaps `V ∩ V'` the descended classes must agree,
  with transition units matching L's comparison — a Čech-Picard gluing over the curve `XA`.
  **(C1) mirror:** the kernel lemma's final `mk_eq_mk_iff` assembly over the affine
  refinement (`CechKernelLemma.lean:291-346`) does the analogous local-to-global step (there:
  cobounding units glue; here: local classes glue). The clopen/finite-product toolkit (§2b)
  glues on the affine BASE, not on curve opens, so it is NOT directly applicable — this is
  the least-charted step. HIGH risk / possible balloon (see §5).

### Route B — direct global descent unit (alternative, closer to the (C1) close)

- **B1 — a single "comparison descent unit" for `cg`, no per-piece localization.** Instead
  of localizing on `XA`, try to build (as in the (C1) `w`) a global object on the affine
  base carrying the descent, then descend `L` in one move. **Obstruction:** in (C1), `w`
  existed because `L` was *trivial on the cover* (a global trivializing `β`); in (C2) `L` is
  nontrivial on the cover, so there is no global unit to build `w` from. Route B therefore
  cannot mirror the (C1) `w` directly; any global object must be a *sheaf* on the curve, i.e.
  it degenerates back into per-piece data. **Trade-off:** Route B avoids A4's curve-gluing
  but reintroduces it inside B1; it looks strictly harder. Recorded for completeness; Route A
  is the correction record's choice and appears more tractable.

### Optional / downstream

- **G5 — global functorial (C2). [MIX, optional].** `picEtUnit.app T` iso over
  section-admitting `T`; affine case is R0 transported through `picEtAffineEquiv`; general
  `T` glues over affine opens (Layer-2 `picEt` sheaf-uniqueness). Land only if Wave 4 asks.
- **Blueprint bookkeeping. [indep].** A `(C2)/Effectivity` chapter with `\source{kleiman-picard}`
  anchors on `th:cmp` Part 2, `df:rgd`, `lm:idn`, `lm:aut` (blueprint agent, concurrent).

### Dependency order

`A1` (affine pieces + ring id) → `A2` (σ-normalized coherent cochain; the hard core, needs
G2 + A1) → `A3` (per-piece brick 4; needs A2) → `A4` (reassembly; needs A3) → effectivity
brick §0.3 → `R0` (surjectivity) → `unitEquiv_of_section`. `G5` after. R0 and blueprint are
independent of the hard core and can be drafted early against the effectivity signature.

---

## §4. What Kleiman's text actually does at this step

Read: `references/kleiman-picard-src/kleiman-picard.tex` — `th:cmp` L1384-1399; Part-1 proof
L1454-1481; `df:rgd` L1483-1488; `lm:idn` L1490-1513; `lm:aut` L1515-1531; **Part-2 proof
L1533-1564**; `rk:coh`/`eq:2b`-`eq:2c` L1566-1605 (the cohomological alternative).

**Kleiman's Part-2 effectivity step (L1542-1554), verbatim in shape.** Given a section `g`
and `λ ∈ Pic_{(X/S)fppf}(T)`, represent `λ` by `λ' ∈ Pic_{X/S}(T')` on an fppf cover
`T' → T`, with an fppf cover `T'' → T' ×_T T'` on which the two pullbacks of `λ'` agree; **by
Part-1 fppf-separatedness one may take `T'' ≅ T' ×_T T'`** (L1538-1540 — this is the landed
(C1) doing its job: separatedness lets the descent datum live on the honest double product,
not a refinement). Then:
1. By `lm:idn` (L1542-1544) represent `λ'` by a rigidified pair `(𝓛', u')`, `𝓛'` invertible
   on `X_{T'}`, `u'` a `g`-rigidification. **← landed G1 + `IsRigidified`.**
2. On `X_{T'×T'}` there is an isomorphism `v'` from the first-projection pullback of
   `(𝓛',u')` to the second (L1544-1546). **← this `v'` is the cochain-level comparison; in
   the cocycle model only its *class* is handed to us by `hdesc` — see the divergence below.**
3. On `X_{T'×T'×T'}`, the triple-overlap `v'₁₃⁻¹ v'₂₃ v'₁₂` is an automorphism of the
   first-projection pullback of `(𝓛',u')`, hence **trivial by `lm:aut`** (L1548-1553).
   **← landed G2 `unitsAppTop_sectionOfPoint_bijective`.**
4. Therefore `(𝓛',u')` descends to `(𝓛,u)` on `X_T`, so `λ ∈ Pic_{X/S}(T)` (L1553-1554).
   **← THE GAP §0.3: the descent of the invertible sheaf along `cg`.**
"The rest is formal" (L1556-1563): the Zariski/étale-local-section variants follow from
Grothendieck-topology sheaf gluing (this is Layer-2 / G5 territory, not the affine core).

**Where the cocycle model diverges (the load-bearing observation).**
- Kleiman works with a *chosen* comparison isomorphism `v'` of sheaves (step 2), so his
  cocycle condition (step 3) is a literal equation between automorphisms, and `lm:aut`
  closes it in one line. **The rebuild's `hdesc` gives only the equality of ISOMORPHISM
  CLASSES `u₁^*L = u₂^*L` — the existence of `v'`, not `v'` itself.** So the rebuild must
  (a) *manufacture* the cochain-level `v'` (a unit-cochain comparison on a cover of `Xq`)
  and (b) *normalize* it with the section (G2) so that step 3's automorphism is not merely
  trivial-up-to-something but literally `1` on the nose. This manufacture+normalize is
  exactly Route-A step A2, and it has no line-level counterpart in Kleiman — it is the price
  of the cocycle (Čech-`H¹`) model, the same price the (C1) `exists_coherentCechWitness`
  paid in the other direction.
- Kleiman's "`(𝓛',u')` descends" (step 4) is effectivity of fppf descent for invertible
  sheaves — a citation for him ("descends"), a full brick for the rebuild (brick 4 +
  reassembly), because the rebuild has no ambient stack/descent formalism and must build the
  descended sheaf affine-locally on the curve and glue.
- Kleiman never localizes on `X_T` — his descent is a single categorical statement. The
  rebuild's per-piece route (A1-A4) is a MODEL-DRIVEN detour forced by `X_T` (the curve
  product) being non-affine, so the affine dictionary `cechPicEquivPic` only applies piece by
  piece. This detour is invisible in Kleiman and is where the rebuild's real labor and real
  risk sit.
- `rk:coh` (L1566-1605) offers Kleiman's cohomological alternative (Leray low-degree exact
  sequence, `g` splitting `H^p(X_T) ← H^p(T)`); the rebuild's `CechPic = Ȟ¹(𝒪^*)` model is
  the `eq:2b` identification, but the rebuild does NOT take the spectral-sequence route — it
  stays with explicit descent, so `rk:coh` is context, not a template.

---

## §5. Honest risks (what could not be verified from reading; balloon points)

1. **A2 (the σ-normalized coherent cochain) is the Fable-grade core and could not be
   sized from reading.** The landed `exists_coherentCechWitness` (its mirror) is ~750 lines
   across `CoherentWitness*.lean` and was itself rebuilt after a monolith died in kernel
   timeouts (session handoff). The (C2) version must additionally thread the section (G2)
   through the normalization — a step with NO (C1) precedent. Estimate: the largest single
   brick, likely multi-session, Fable-authored. The lesson of the G3 correction applies
   directly: do NOT assume the class equation `hdesc` "obviously" yields a coherent cochain;
   it did not for the recon's G3, and the coherence is precisely the content.

2. **A4 (reassembly on the curve) has no landed analogue and may balloon.** Every landed
   gluing primitive (clopen partitions `CechPicClopenGlue`, finite-product `RelPicPi`,
   Zariski `away` `PicEtAffZariskiGlue`) glues Picard classes on the AFFINE BASE `Spec A` or
   a finite product — NOT local classes on affine opens of the CURVE `XA`. Gluing per-piece
   `M_V ∈ V.CechPic` into a global `M ∈ XA.CechPic` with a prescribed `cg^*M = L` is a
   Čech-Picard local-to-global step on a non-affine scheme. The kernel lemma's final
   assembly (`CechKernelLemma.lean:291-346`) is the closest pattern (it glues cobounding
   units over an affine refinement of `XA`), but it glues to prove a class is `1`, not to
   CONSTRUCT a class with a prescribed pullback. Whether the effectivity is better organized
   as (i) construct `M` then verify `cg^*M = L`, or (ii) a single `mk_eq_mk_iff` cohomology
   argument avoiding an explicit `M`, is an open organizational question — see the design
   decision below.

3. **A1's ring identification `Γ(cg⁻¹V) ≅ Γ(V) ⊗_A B` was not verified.** Plausible
   (`cg` is the affine base change of `A → B`) and the `⊤`-case is landed
   (`sectionsTopAlgEquiv : Γ(XB,⊤) ≃ₐ[A] B`), but the general-affine-open case and its
   faithful flatness were not checked against mathlib. Could be a clean `IsLocalization`/base-
   change lemma or could need infrastructure. Medium uncertainty.

4. **Does the effectivity truly need `σ`, or only `hdesc`?** Reading strongly indicates YES,
   σ is needed (§0.3 argument; the correction record's "σ-normalized cobounding"; the (C1)/
   (C2) section asymmetry mirroring Kleiman Part-1/Part-2). But this was not machine-checked;
   a prover might discover the on-the-nose `hdesc` already carries enough rigidity to skip G2
   in some sub-step, or (worse) discover `hdesc` is insufficient and MORE section data is
   needed (e.g. the rigidification of `L` itself, `hrig`, beyond just `hdesc`). The
   signature in §0.3 carries BOTH `hrig` and `hdesc` defensively; the orchestrator should
   treat their exact necessity as a design variable.

5. **Interaction with the `[proper + gi + gr]` instance triple.** G2 and `prPullback_injective`
   need the triple; `cechPicEquivPic`/brick 4 do not. The effectivity brick must carry the
   triple (for G2) and thread it through the per-piece localizations — the (C1) close manages
   this (`EtaleSeparatednessClose.lean:63`, `attribute [local instance]` section-algebra
   block :67), so the pattern exists, but the piece rings `Γ(V)` introduce fresh section-
   algebra instances that were not audited.

6. **Not verified by build.** Per constraints, no `lake build` was run (prover holds the
   lock) and no proof was attempted. All signatures are read from source at the cited lines;
   the prover MUST re-confirm shapes with the LSP before proving (the tree moves under the
   build lock).

---

## Appendix — one-paragraph orientation for the worksheet-writer

The rigidification layer (G0-G2) and the Layer-2 unit (G4) are LANDED and axiom-clean; the
surjectivity reduction (R0) is a one-screen dual of the landed (C1) unfold. The ENTIRE
remaining campaign is one effectivity brick (§0.3): a rigidified invertible sheaf `L` on the
curve over an étale cover, whose two double-cover pullbacks are equal as classes (`hdesc`,
handed over on the nose by the landed `IsRigidified.cechPicMap_doubleInl_eq_doubleInr`),
descends along the cover inclusion `cg` on the curve product to a sheaf downstairs — using
the section (G2) to normalize the cochain-level comparison the class equation only asserts to
exist. It is the exact DUAL of the landed (C1) kernel lemma
`exists_cechPic_map_snd_of_ker_whiskerLeft`, and its hard core (A2, the σ-normalized coherent
cochain) is the mirror of the (C1) `exists_coherentCechWitness`, with the section replacing
the upstairs trivialization as the source of coherence.
