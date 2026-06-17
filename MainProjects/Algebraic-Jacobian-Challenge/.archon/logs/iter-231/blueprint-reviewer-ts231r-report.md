# Blueprint Review Report

## Slug
ts231r

## Iteration
231

## Top-level summaries

### Incomplete parts

- `Albanese_CodimOneExtension.tex`: Chapter covers `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
  (A.4.a, codimension-1 indeterminacy extension). Only 9 `\leanok` instances in 1707 lines — a large
  chapter with many declarations not yet marked formalized. This is gated on Milne Thm 3.2 / Lemma 3.3 /
  Weil-divisor infrastructure, so the gap is intentional, but plan agent should confirm no active prover
  is being dispatched here.
- `RigidityKbar.tex`: The headline `thm:rigidity_over_kbar` is a named gap (`sorry` body, explicitly
  documented). Several piece (i.b) declarations were excised from the Lean tree (iter-145 chart-algebra
  pivot); the blueprint blocks for excised declarations are retained for traceability but their `\lean{}`
  hints point at non-existent declarations. This is documented as intentional. Not a new finding but
  the chapter is structurally `partial`.
- `Cohomology_StructureSheafModuleK.tex`: Contains a "Tier-3 honest typed sorry" substrate (closure
  depends on Serre finiteness, not yet available). This is an honest gap pin, not a blueprint error.
- `Jacobian.tex`: `thm:nonempty_jacobianWitness` is the single named gap of the entire project (sorry
  body). All other declarations in the chapter have `\leanok`. This is the expected state.

### Proofs lacking detail

- `Picard_QuotScheme.tex` / `lem:quot_boundedness`: The proof sketch says "The Castelnuovo-Mumford
  m-regularity theorem of [Nitsure] §2 produces..." and cites Mathlib-absent CM regularity. The proof
  step is acknowledged as requiring infrastructure not yet in Mathlib, but no blueprint chapter
  blueprints that infrastructure. **Actionable**: the unstarted-phase proposals below address this
  directly.
- `Albanese_AlbaneseUP.tex` / `lem:symmetric_product_to_jacobian`: The birationality proof uses
  Riemann-Roch (`h^0(D) - h^1(D) = 1` at deg g) — the Route C substrate. A NOTE block flags this
  as gated on Route C re-engagement. Proof is complete for the existence direction.

### Lean difficulty quality

- `Picard_RelPicFunctor.tex` / `def:rel_pic_sharp` (`\lean{AlgebraicGeometry.Scheme.PicSharp}`):
  An extensive NOTE block documents that the current Lean body is a constant-PUnit-functor placeholder
  ("the zero map between two trivial-group endpoints"). The blueprint correctly documents the gap and
  the gate. No prover should be dispatched to this file until the TensorObjSubstrate inverse lands.
- `Picard_IdentityComponent.tex` / various `lem:geometricallyConnected_of_connected_of_section`:
  The `\lean{...}` pin is long and non-standard. The Lean target is novel project material with no
  Mathlib analogue; a prover would need to build the abstract substrate from scratch. Acceptable given
  the chapter documents this clearly, but the proof sketch is complex (EGA IV₂ 4.5.14, 4.6.1, etc.
  are not Mathlib lemmas — provers would need to translate them).

### Citation discipline

All citation elements (% SOURCE:, % SOURCE QUOTE:, \textit{Source:}) spot-checked for the focus
chapter `Picard_TensorObjSubstrate.tex` and for `Picard_FGAPicRepresentability.tex`,
`Picard_RelPicFunctor.tex`, `Picard_QuotScheme.tex`, and `AbelianVarietyRigidity.tex`.

No hard-fail citation discipline findings. The `(read from references/...)` parentheticals present
and consistent throughout. Verbatim quotes are in the source's original language (English for
Mathlib/Stacks/English sources; Kleiman, Nitsure, Milne are all English). No paraphrase-passing-as-quote
detected in checked chapters.

One informational note: `Picard_IdentityComponent.tex` cites EGA I 6.1.9 and EGA IV₂ 4.5.8, 4.5.14,
4.6.1 in proof bodies without `% SOURCE QUOTE:` lines. These are standard EGA references and the blocks
are architecturally original (Archon-internal assembly), so the absence of verbatim EGA quotes is not a
hard fail under the citation-discipline rules, but a plan agent should confirm these are Archon-original
proofs assembling external references rather than translations.

---

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Cohomology_HigherDirectImages.tex`

**Covers**: `AlgebraicJacobian/Cohomology/HigherDirectImages.lean` (new file)
**Strategy phase**: A.2.c-engine — Quot/Cartier (ungated foundational root)
**Why now**: `R^i f_*` (i ≥ 1) is the deepest root of the Quot/Hilbert engine (`lem:quot_boundedness`
in `Picard_QuotScheme.tex` already cites it; `thm:flat_base_change_cohomology` covers only i=0). This
piece is **genuinely ungated**: it depends on no project infrastructure, only Mathlib scheme + coherent
sheaf foundations. Writing the blueprint now enables a parallel prover lane for `R^i f_*`
independently of the ⊗-inverse substrate currently on the critical path.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:higher_direct_image_functor}` — For a quasi-compact quasi-separated
   morphism f: X → S and a quasi-coherent O_X-module F, the i-th higher direct image sheaf
   R^i f_* F is the i-th right derived functor of the pushforward f_* applied to F.
   `\lean{AlgebraicGeometry.higherDirectImage}` [expected]. Source: Stacks 01XJ (pushforward) +
   029X (derived pushforward for qcqs morphisms); `references/stacks-constructions.tex` §relative-spec.
2. `\lemma` `\label{lem:higher_direct_image_zero_is_pushforward}` — R^0 f_* F ≅ f_* F, the base case.
   `\lean{AlgebraicGeometry.higherDirectImage_zero}` [expected]. Source: standard (Grothendieck,
   Tôhoku); Stacks 01XJ.
3. `\lemma` `\label{lem:higher_direct_image_vanishing_affine}` — If S is affine and f is affine,
   R^i f_* F = 0 for i ≥ 1 (affineness implies cohomological dimension 0). Lean:
   `AlgebraicGeometry.higherDirectImage_affine_vanishing` [expected]. Source: Stacks 01XK;
   Hartshorne III.5.2 consequence.
4. `\theorem` `\label{thm:flat_base_change_higher_direct_image}` — For a cartesian square with g flat,
   g* R^i f_* F ≅ R^i f'_* (g')* F for all i ≥ 0. This is Stacks 02KH (already stated as
   `thm:flat_base_change_cohomology` in `Picard_QuotScheme.tex` for i=0 only); here extend to i ≥ 1.
   `\lean{AlgebraicGeometry.flatBaseChange_higherDirectImage}` [expected]. Source: Stacks 02KH;
   `references/stacks-coherent.tex`.
5. `\lemma` `\label{lem:higher_direct_image_serre_vanishing}` — Serre vanishing: for f: X → S
   projective with L relatively very ample, R^i f_*(F ⊗ L^n) = 0 for i ≥ 1 and n ≫ 0. This is
   what powers Castelnuovo-Mumford regularity.
   `\lean{AlgebraicGeometry.higherDirectImage_serreVanishing}` [expected]. Source: Hartshorne III.5.2;
   Stacks 02O5.

**`\uses` skeleton**:
- `thm:flat_base_change_higher_direct_image` uses `def:higher_direct_image_functor`,
  `lem:higher_direct_image_zero_is_pushforward`
- `lem:higher_direct_image_serre_vanishing` uses `def:higher_direct_image_functor`,
  `lem:higher_direct_image_vanishing_affine`
- `lem:higher_direct_image_vanishing_affine` uses `def:higher_direct_image_functor`,
  `lem:higher_direct_image_zero_is_pushforward`

**Main theorem proof strategy**: Define R^i f_* via Čech cohomology on an affine open cover of X
(Stacks 01XX–01YF), or directly as the i-th derived functor of f_* in the abelian category of
quasi-coherent sheaves (exists by Grothendieck, Tôhoku). Prove vanishing on affine morphisms by
comparing with ring-theoretic Ext (Mathlib: `Algebra.Ext`, available). Prove flat base change
by the abstract lemma that right-derived functors commute with exact base change (Stacks 02KH);
the Lean incarnation already partially exists as the i=0 case `thm:flat_base_change_cohomology`.
Serre vanishing follows from the Castelnuovo-Mumford regularity argument plus twisting.

**References for writer**:
- `references/stacks-coherent.tex` → stacks-coherent.tex, §02KH — base change for R^i f_*
- `references/stacks-constructions.tex` → stacks-constructions.tex, §01XJ–01YF — higher direct images
- retrieval needed: Nitsure `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` §3 (base
  change for flat sheaves, the version feeding into lem:quot_boundedness) — already partially read
  by the writer who produced QuotScheme.tex

**Subphase choices exposed**:
- Čech route vs. derived-functor abstract route: Čech is more concrete and closer to Lean's existing
  infrastructure (Mathlib has Čech cohomology for Top spaces); abstract derived functors need an
  abelian-category framework for Qcoh(X). Recommendation: Čech route first for i=1 (most urgently
  needed by the Quot engine), then extend.
- Whether to handle i=1 only (sufficient for Serre vanishing in the Quot boundedness step) or to
  develop general R^i f_*: recommended to do general from the start to avoid duplicate work.

---

### Proposed chapter: `blueprint/src/chapters/Picard_CastelnuovoMumford.tex`

**Covers**: `AlgebraicJacobian/Picard/CastelnuovoMumford.lean` (new file)
**Strategy phase**: A.2.c-engine — Quot/Cartier (ungated, gated behind HigherDirectImages above)
**Why now**: `lem:quot_boundedness` in `Picard_QuotScheme.tex` invokes the Castelnuovo-Mumford
m-regularity theorem ("there exists m = m(n, p, Φ) such that...") without a blueprinted proof.
Writing this chapter creates a standalone proof obligation that a prover can work on in parallel
with the ⊗-inverse substrate, given that `HigherDirectImages.lean` lands first.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:cm_regularity}` — A coherent sheaf F on P^n_k (or more generally on
   P(V) over a Noetherian base) is m-regular if H^i(P^n, F(m-i)) = 0 for all i ≥ 1. Lean:
   `AlgebraicGeometry.CMRegular` [expected]. Source: Nitsure §2; Mumford "Lectures on Curves";
   `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` §2.
2. `\lemma` `\label{lem:cm_regularity_global_generation}` — An m-regular sheaf is globally generated
   (by H^0(F(m))). Lean: `AlgebraicGeometry.CMRegular.globallyGenerated` [expected]. Source:
   Mumford / Nitsure §2.
3. `\lemma` `\label{lem:cm_regularity_vanishing}` — F m-regular ⟹ H^i(F(n)) = 0 for i ≥ 1, n ≥ m-i.
   Lean: `AlgebraicGeometry.CMRegular.higherVanishing` [expected]. Source: Nitsure §2.
4. `\theorem` `\label{thm:cm_regularity_uniform_bound}` — For E = π*W on P(V) with V, W vector
   bundles of ranks n+1, p on S, and Hilbert polynomial Φ, there exists m = m(n, p, Φ) such that
   for every geometric point s and every quotient q: E_s → F with Hilbert polynomial Φ, the sheaves
   E_s, F, and ker(q) are all m-regular. Lean: `AlgebraicGeometry.cmRegularityUniformBound`
   [expected]. Source: Nitsure §2 Theorem "Mumford";
   `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` §2.

**`\uses` skeleton**:
- `thm:cm_regularity_uniform_bound` uses `def:cm_regularity`, `lem:cm_regularity_vanishing`,
  `lem:cm_regularity_global_generation`
- `lem:cm_regularity_vanishing` uses `def:cm_regularity`
- `lem:cm_regularity_global_generation` uses `def:cm_regularity`, `lem:cm_regularity_vanishing`

**Main theorem proof strategy**: CM regularity of the uniform bound follows from the classification
of coherent sheaves on P^n over an algebraically closed field together with the Hilbert function
being a polynomial (Snapper's lemma). The key step is showing that the regularity of a coherent
quotient of E_s depends only on the ranks and the polynomial Φ, not on the specific quotient.
This uses induction on the dimension of the support. Nitsure §2 contains the full proof.

**References for writer**:
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` §2 — CM regularity (Theorem
  "Mumford" + §2 buildup)
- retrieval needed: Mumford "Lectures on Curves on an Algebraic Surface" §14 for the original
  m-regularity definition — no local file, writer should use Nitsure §2 which contains the proof

**Subphase choices exposed**:
- Whether to treat P^n_k (constant coefficients) first or go directly to the relative P(V) over S:
  Recommendation: build P^n_k first (~150 LOC easier), then extend to P(V) via base change.

---

### Proposed chapter: `blueprint/src/chapters/Picard_RelativeProj.tex`

**Covers**: `AlgebraicJacobian/Picard/RelativeProj.lean` (new file)
**Strategy phase**: A.2.c-engine (Grassmannian embedding step; partially ungated)
**Why now**: The Grassmannian embedding of the Quot scheme (`lem:quot_alpha_injective` in
`Picard_QuotScheme.tex`) requires the assertion that `π* E(r)` on P(V) over S identifies with
`W ⊗ Sym^r V` via the standard projective structure. The Relative Proj construction and its
pushforward identities are not separately blueprinted — they are alluded to in the Quot proof
but never given their own blueprint chapter. This is an ungated foundational piece: it needs
only basic scheme infrastructure and Mathlib's Proj construction.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:relative_proj_scheme}` — For a graded O_S-algebra A = ⊕ A_n on a
   Noetherian scheme S, the relative Proj Proj_S(A) is a scheme over S representing the functor of
   graded quotients. Lean: `AlgebraicGeometry.Scheme.RelativeProj` [expected]. Source: Stacks 01O9;
   `references/stacks-constructions.tex` §relative-Proj.
2. `\theorem` `\label{thm:relative_proj_universal_property}` — Proj_S(A) represents the graded-quotient
   functor; on affines it reduces to the standard Proj of the ring. Lean:
   `AlgebraicGeometry.Scheme.RelativeProj.representable` [expected]. Source: Stacks 01O9.
3. `\lemma` `\label{lem:relative_proj_projective_space}` — For the polynomial algebra A = Sym(E) with
   E a locally free O_S-module of rank n+1, Proj_S(Sym(E)) = P(E) is the projective bundle of lines
   in E. Lean: `AlgebraicGeometry.Scheme.ProjectiveBundle` [expected]. Source: Stacks 01O9 / EGA II
   §4.1.
4. `\lemma` `\label{lem:relative_proj_tautological_line_bundle}` — On Proj_S(Sym(E)) there is a
   tautological relatively very ample line bundle O(1) whose global sections over an affine U = Spec A
   are the degree-1 component of Sym(E(U)). Lean:
   `AlgebraicGeometry.Scheme.ProjectiveBundle.tautologicalBundle` [expected]. Source: Stacks 01O9.
5. `\lemma` `\label{lem:relative_proj_pushforward_twist}` — For π: P(E) → S with L = O(1),
   π_*(F ⊗ L^n) ≅ Sym^n(E) ⊗ π_*(F) for a coherent F on P(E) and n ≥ 0. This is the identification
   consumed by `lem:quot_alpha_injective`. Lean:
   `AlgebraicGeometry.Scheme.ProjectiveBundle.pushforwardTwist` [expected]. Source: Nitsure §5 /
   Stacks 02NM.

**`\uses` skeleton**:
- `thm:relative_proj_universal_property` uses `def:relative_proj_scheme`
- `lem:relative_proj_projective_space` uses `thm:relative_proj_universal_property`
- `lem:relative_proj_tautological_line_bundle` uses `lem:relative_proj_projective_space`
- `lem:relative_proj_pushforward_twist` uses `lem:relative_proj_tautological_line_bundle`,
  `lem:higher_direct_image_zero_is_pushforward` (from proposed `Cohomology_HigherDirectImages.tex`)

**Main theorem proof strategy**: Use Mathlib's existing `Proj` construction (already used for the
projective line in `AbelianVarietyRigidity.tex`). The universal property follows from the standard
affine gluing. The projective bundle and its tautological bundle are constructed via the
`AlgebraicGeometry.Scheme.GlueData` pattern. The pushforward twist identity uses projection formula
+ the direct image computation on affine charts.

**References for writer**:
- `references/stacks-constructions.tex` → §01O9 (Relative Proj) — already a local file
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` §1 — Grassmannian construction
  which relies on Proj
- Mathlib: `AlgebraicGeometry.ProjectiveSpectrum` is the existing `Proj` implementation —
  writer should check how `ProjectiveLineBar` used it in `AbelianVarietyRigidity.tex`

**Subphase choices exposed**:
- Whether to develop general Relative Proj (all graded algebras) or just the polynomial algebra
  Sym(E) case: Recommendation: Sym(E) case first (needed by the Quot engine; 5× simpler to state
  than the general case). The general Relative Proj can follow as a generalization.
- Dependency on `HigherDirectImages.tex`: `lem:relative_proj_pushforward_twist` needs R^0 f_* only
  (not R^i for i≥1), so this chapter is partially ungated even without the HigherDirectImages chapter.

---

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 47 `\leanok` markers; the headline propositions `prop:morphism_P1_to_AV_constant` (line 2820)
    and `prop:rigidity_genus0_curve_to_AV` (line 2949) both have `\leanok`.
  - `lem:projectiveLineBar_isProper` does NOT have `\leanok`; the proof note (iter-196) says
    smoothness closure is pending a chart-ring iso scope issue. This is a prover objective, not a
    blueprint error.
  - `lem:rational_map_to_av_extends` (Milne Thm 3.2) carries a "Route-A-only" flag and the
    proof body references Mathlib Weil-divisor gaps — correctly documented.
  - The chapter covers 7 Lean files via `archon:covers`; all are adequately described.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 22 `\leanok` markers. Chapter covers Auslander-Buchsbaum; part of A.4.a infrastructure.
    Gated on Milne Thm 3.2 / Lemma 3.3 Weil-divisor infrastructure; blueprint documents this.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Only 9 `\leanok` markers in 1707 lines. A large chapter with many declarations not yet
    formalized, as expected (A.4.a is gated). Blueprint proof sketches are sound.
  - No active prover objective here (chapter gated on Weil-divisor infrastructure).

### blueprint/src/chapters/Albanese_CoheightBridge.tex
- **complete**: true
- **correct**: true
- **notes**: 8 `\leanok` markers; supporting bridge for coheight/Krull dimension.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: true
- **correct**: true
- **notes**: 1 `\leanok` marker (`thm:rational_map_to_av_extends` statement). Proof sketch
  references Milne Thm 3.1 + Lemma 3.3 (Weil-divisor gap); correctly documented.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**: Contains a "Tier-3 honest typed sorry" substrate waiting on Serre finiteness.
  Multiple `\leanok` markers; gap is honestly documented and expected.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex
- **complete**: true
- **correct**: true
- **notes**: 4 `\leanok` markers; substrate chapter for Cross01Substrate.lean.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:nonempty_jacobianWitness` is the project's single named gap (sorry body, documented).
  - All other declarations in the chapter have `\leanok`.
  - The bundled `JacobianWitness` approach is correct for the current project state.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All major declarations present and marked `\leanok`. The iterative BC substrate
    (iter-189 onwards) is well-described with detailed 6-stage proof decomposition.
  - `lem:quot_boundedness` proof references CM regularity (Mathlib-absent). This is documented
    honestly and is the subject of the proposed `Picard_CastelnuovoMumford.tex` chapter.
  - `thm:flat_base_change_cohomology` covers only i=0; i≥1 case referenced but not fully
    blueprinted — addressed by proposed `Cohomology_HigherDirectImages.tex`.
  - The pushforward-twist identity `π_*(E(r)) ≅ W ⊗ Sym^r V` used in `lem:quot_alpha_injective`
    assumes Relative Proj infrastructure; this is addressed by proposed `Picard_RelativeProj.tex`.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:rel_pic_sharp` Lean body is a constant-PUnit placeholder (documented via NOTE blocks);
    the gate is the TensorObjSubstrate addCommGroup. Blueprint correctly gates this.
  - `thm:rel_pic_etale_sheaf_unit_canonical` is forward-looking with no `\lean{}` pin; correctly
    marked as deferred.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Gate confirmation (iter-231 directive)**: `lem:dual_isLocallyTrivial` proof recipe is
    correctly updated to use the minimal objectwise V⊆U route. The proof body at lines 2930–3008
    describes the correct approach: Steps 1–3 reduce restriction to abstract pullback and strip
    sheafification (reused from `lem:tensorobj_restrict_iso`); then the residual
    `(pushforward β).obj(dual A) ≅ dual((pushforward β).obj A)` is resolved **objectwise** per
    section V⊆U using the sectionwise ring iso `f#_V` and `restrictScalarsRingIsoDualEquiv`, with
    naturality automatic (thin poset). An explicit "Route note (iter-230, settled empirically)"
    rules out routing through `overSliceSheafEquiv` (value-cat-fixed; cannot transport varying-ring
    module fibration). **This is the corrected recipe the directive describes. The chapter passes
    the hard gate for `Picard/TensorObjSubstrate.lean`.**
  - `lem:tensorobj_assoc_iso` proof notes that the current Lean realization uses the route-(d)
    whiskering composite (transitively depends on an open obligation) while the intended gluing
    route is blueprinted. This is documented honestly; the blueprint describes the correct target.
  - `lem:sheafofmodules_hom_of_local_compat` (homOfLocalCompat) has a detailed proof sketch
    (existsUnique_gluing + presheafHomSectionsEquiv + homMk pattern). The localSection naturality
    is flagged as the dominant risk; the proof body names the risk explicitly. Sufficient for a
    prover.
  - `lem:tensorobj_restrict_iso` H1 residual (presheaf-level pushforward adjunction) is the active
    prover target; blueprint proof is detailed and correct.
  - All `\uses{}` references in this chapter resolve inside this chapter or in
    `Picard_LineBundlePullback.tex` (on disk). No broken cross-refs.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: partial
- **correct**: true
- **notes**: Route C (USER PAUSE). Chapter has declarations and proof sketches but is in a paused
  state per standing directive. Not a blueprint error; reflects the project's intentional route
  choices.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: partial
- **correct**: true
- **notes**: Route C (USER PAUSE). Same disposition as H1Vanishing.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex
- **complete**: partial
- **correct**: true
- **notes**: Route C (USER PAUSE).

### blueprint/src/chapters/RiemannRoch_RRFormula.tex
- **complete**: partial
- **correct**: true
- **notes**: Route C (USER PAUSE). 13 `\leanok` markers.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: partial
- **correct**: true
- **notes**: Route C (USER PAUSE).

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: partial
- **correct**: true
- **notes**: Route C (USER PAUSE). 25 `\leanok` markers.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` is a named gap (sorry body, explicitly documented in chapter intro).
  - Multiple piece (i.b) declarations were excised from the Lean tree (iter-145 chart-algebra
    pivot). Blueprint blocks for excised declarations are retained for traceability but their
    `\lean{}` hints point at non-existent declarations. This is documented as intentional.
  - The chart `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` and companions in
    `AlgebraicJacobian_Cotangent_GrpObj.tex` reference still-existing declarations.
  - No active prover should be dispatched to `RigidityKbar.lean` or `Cotangent/ChartAlgebra.lean`
    without first resolving the cotangent-vanishing keystone (gap (i) or gap (ii) in chapter intro).

---

## Cross-chapter notes

- `Picard_RelPicFunctor.tex` carries a NOTE that `PicSharp.addCommGroup` is gated on the Lean
  addCommGroup instance for `LineBundle.OnProduct`, which in turn gates on
  `Scheme.Modules.tensorObj` (i.e., `Picard_TensorObjSubstrate.tex`). The gate chain is correct.
- `Picard_FGAPicRepresentability.tex` references label `def:rel_pic_etale_sheafification` which
  lives in `Picard_RelPicFunctor.tex` and `thm:quot_representable` in `Picard_QuotScheme.tex`.
  Both are correctly present in those chapters.
- `Picard_IdentityComponent.tex` references `def:pic_scheme` (in FGAPicRepresentability.tex) and
  `def:hilbert_polynomial` (in QuotScheme.tex) — both verified present.
- `Albanese_AlbaneseUP.tex` references `lem:symmetric_product_to_jacobian` which internally uses
  Riemann-Roch (RR pause). The NOTE block flags this correctly; the proof proof is gated on
  Route C re-engagement.

---

## Severity summary

**must-fix-this-iter**:
1. `unstarted-phase proposal: A.2.c-engine root — dispatch blueprint-writer for
   `blueprint/src/chapters/Cohomology_HigherDirectImages.tex` or record deferral.`
2. `unstarted-phase proposal: A.2.c-engine root — dispatch blueprint-writer for
   `blueprint/src/chapters/Picard_CastelnuovoMumford.tex` or record deferral.`
3. `unstarted-phase proposal: A.2.c-engine root — dispatch blueprint-writer for
   `blueprint/src/chapters/Picard_RelativeProj.tex` or record deferral.`

No hard-gate blocking findings. `Picard_TensorObjSubstrate.tex` passes: `complete: true`,
`correct: true`, no must-fix findings — the iter-231 prover for `Picard/TensorObjSubstrate.lean`
may proceed.

**soon** (not blocking active lanes):
- `Picard_IdentityComponent.tex` / EGA citations in proof bodies: confirm these are Archon-original
  proofs assembling external references (not translations needing `% SOURCE QUOTE PROOF:`).
- `RigidityKbar.tex` excised `\lean{}` hints: consider stripping or adding `% EXCISED` markers to
  prevent blueprint-doctor false positives on non-existent declarations.
- `Albanese_CodimOneExtension.tex`: only 9 `\leanok` in 1707 lines — plan agent should verify no
  prover is being dispatched here until Weil-divisor infrastructure lands.

Overall verdict: **Blueprint health is good for the active prover lanes; `Picard_TensorObjSubstrate.tex`
PASSES the hard gate with the corrected `lem:dual_isLocallyTrivial` recipe; 3 phases of the A.2.c engine
have no blueprint coverage — proposals provided for immediate writer dispatch (or explicit deferral).**
