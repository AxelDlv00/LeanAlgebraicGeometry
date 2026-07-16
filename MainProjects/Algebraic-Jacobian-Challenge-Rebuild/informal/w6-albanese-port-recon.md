# Wave-6 Albanese PORT recon — what the old Albanese work offers vs what must be rebuilt

**STATUS: RECON, not design.** Written 2026-07-16 by the parallel (non-prover) session.
No Wave-6 worksheet exists yet; this document inventories the existing Albanese
formalization (SubProjects/Albanese + the old AJC in-tree copy at
`MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/`) against the
Rebuild's frozen Wave-6 target and the pinned Milne III.6.1 route. All claims below are
grep/Read-verified against the tree on 2026-07-16; stale prose in old file headers and
roadmap sorry-counts were re-measured, not trusted.

---

## 0. Headline verdict

1. **The substrate matches.** All three projects (SubProjects/Albanese, old AJC,
   Rebuild) share lean4 v4.31.0 and the identical Mathlib pin `fabf563a7c`, and the old
   extraction's conventions are the Rebuild's verbatim: curve = `Over (Spec (.of k))` +
   `[SmoothOfRelativeDimension 1] [IsProper] [GeometricallyIrreducible]`, AV =
   `[GrpObj] [IsProper] [Smooth] [GeometricallyIrreducible]`, points as
   `𝟙_ (Over (Spec (.of k))) ⟶ C`, unit `η[A]`, Mathlib `Scheme.RationalMap`. There is
   **no toolchain or vocabulary seam**; ports are file drops or renames, not
   translations.
2. **~6.3k lines of sorry-free, Mathlib-only material is drop-in portable**: the
   Auslander–Buchsbaum/depth/CM package, the coheight bridge, pole purity, the
   Serre-free smooth-prime-regularity chain, and five rational-map machinery files
   (precomp, prod, function-field pullback, difference map, Milne-3.3 substeps). These
   carry the hard commutative algebra of Milne I 3.1/3.3.
3. **The extension theorem (Milne I 3.2) is one sorry away from ported-and-proved**:
   `extend_to_av` (Thm32RationalMapExtension.lean, code-sorry-free) + CodimOneExtension
   (Milne 3.1 fully proved) rest on exactly one open sorry — Milne Lemma 3.3
   (`indeterminacy_pure_codim_one_into_grpScheme`); of its audited substeps
   {1, 2, 3, 4a, 4b}, substeps 1 and 4a are fully closed and 2, 4b partially closed
   (2-easy topology, 4b transport) by sorry-free bricks — open: 2-hard, 3, and the
   final assembly (matches §2/§3 S5).
4. **The Albanese assembly (AlbaneseUP.lean) ports as shape only**: its headline
   `albanese_universal_property` is proved sorry-free *from* six sorried bricks
   (Abel–Jacobi, Sym^g, the sum-map, f^{(g)}, the birational descent, the
   biconditional). The ∃!-plumbing and file architecture transfer; no substantive proof
   content does. Re-target `jacobianScheme C` ↦ `Jacobian C`, `abelJacobi` ↦
   `Jacobian.ofCurve`, old `genus` ↦ Rebuild `genus`; **do not port** the old-draft Pic⁰
   `bundle` wiring (binds to `HasPicScheme`/`Pic0AbelianVariety`, architecture the
   Rebuild replaced).
5. **Two gaps no port touches**: (a) the old stack's geometry/extension/shape layers
   (CodimOneExtension, Thm32RationalMapExtension, AlbaneseUP) are pinned
   `[IsAlgClosed kbar]`; the pure-algebra and rational-map bricks are field-generic
   but carry no descent content — so the k̄→k uniqueness-first Galois descent
   (Milne 6.4-pattern) has zero landed or portable material; (b) Sym^g C as a scheme is untouched
   everywhere (the planned old-draft SymmetricPower substrate file was never opened),
   and the Wave-4 datum campaign deliberately builds Div^g-lite *instead of* C^(g),
   dissolving route item 16's cost-sharing premise.

## 1. The real Wave-6 targets

### 1.1 Frozen signatures (Challenge.lean, verified this pass)

Standing context (`Challenge.lean:57-63`): `{k} [Field k]`, `C : Over (Spec (.of k))`,
instances `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
[GeometricallyIrreducible C.hom]`. **No genus hypothesis anywhere.**

- `Jacobian C` (`:96-99`, sorried data) + `instGrpObj` (`:107-108`) — Wave-4 pins,
  realized per the binding datum worksheet as `(jacobianData C).J` and
  `GrpObj.ofRepresentableBy` on `rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙
  forget GrpCat).RepresentableBy J` (`informal/w4-datum-worksheet.md:68-75`). The
  carrier `pic0Functor` is LANDED (`Picard/Pic0Functor.lean:151`, ledger `6bd5c9dca`).
- Wave-5 instance pins: `smoothOfRelativeDimension_genus` (`:112-113`),
  `IsProper (Jacobian C).hom` (`:116-117`), `GeometricallyIrreducible (Jacobian C).hom`
  (`:120-121`) — all sorried, none started.
- `ofCurve (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : C ⟶ Jacobian C` (`:125-126`) and
  `comp_ofCurve : P ≫ ofCurve P = η[Jacobian C]` (`:130-134`) — per the binding
  consumption map these are **fed by the degree lane, not Wave-6-owned**:
  `ofCurve P := rep.homEquiv.symm (abelElement P)` with `abelElement` = G-D8 (not
  landed; its graph ingredient `graphPicClass` + `graphLocalEquations_base_change` IS
  landed, `Curve/GraphDivisor.lean:245,263`) — `w4-datum-worksheet.md:143`.
- **The Wave-6 deliverable** (`w4-datum-worksheet.md:145`: "Wave 6 (Albanese),
  consuming `rep`"):

```lean
theorem exists_unique_ofCurve_comp (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C)
    {A : Over (Spec (.of k))} [Smooth A.hom] [IsProper A.hom] [GrpObj A]
    [GeometricallyIrreducible A.hom] (f : C ⟶ A) (hf : P ≫ f = η[A]) :
    ∃! (g : Jacobian C ⟶ A), f = ofCurve P ≫ g   -- Challenge.lean:141-147
```

  Note: the competitor `g` is a **plain `Over`-morphism** (no hom condition), `A` has
  no dimension/commutativity/rational-point hypotheses, and `k` is an arbitrary field.
- `functor` (`:153-158`), `baseChangeIso` + coherences (`:244-272`),
  `baseChange_ofCurve` (`:278-283`) are Wave 7, consuming `jacobianData` at every
  curve.

### 1.2 The pinned Milne III.6.1 route skeleton (route-decision.md §1, §3, items 16-18)

Milne AV III.6.1 (READ this pass from `references/abelian-varieties.pdf`, PDF p. 110 —
no workspace transcription covers it, see §4.4; standing hypothesis of
III §§5-6 is **g > 0**): the symmetric sum `(P₁,…,P_g) ↦ Σ φ(Pᵢ) : C^g → A` factors
through `C^(g)`, hence a rational map `ψ : J ⇢ A` through the birational `f^(g)`
(Thm 5.1a); I 3.2 (= I 3.1 + Lemma 3.3, verbatim "Combine Theorem 3.1 with the next
lemma") makes ψ regular; ψ(0)=0 + I 1.2 makes it a homomorphism; uniqueness because two
homomorphisms agreeing on `f^P(C)` agree on `W^g = J`. The challenge's plain-morphism
clause is handled by the route's pointedness calc (`route-decision.md:95-99`):
`η ≫ g = P ≫ ofCurve P ≫ g = P ≫ f = η`, then rigidity upgrades `g` to a homomorphism.
Descent k̄→k is uniqueness-first (Milne 6.4-pattern: uniqueness forces `σψ = ψ`).

### 1.3 The W6-seam ledger — what Wave 4/5 will have staged (terminology hazard)

**"W6" in the worksheets is a G-D2 degree-lane sub-brick, NOT Wave 6**
(`deg-d2-meromorphic-worksheet.md` AMENDMENT; split in `w4-flv-worksheet.md` §3):

- **W6-lite — LANDED**: h⁰/h¹/H¹-vanishing well-defined on Picard classes
  (`h0_divisorSheaf_eq_of_picClass_eq`, `h1_divisorSheaf_eq_of_picClass_eq`,
  `subsingleton_hModule_one_of_picClass_eq`,
  `RiemannRoch/ClassCohomology.lean:89,98,111`; ledger `d2c3376f8`).
- **W6-full — OPEN, spec frozen as DAT-3** (`w4-datum-worksheet.md` §3.1): gluedSheaf ≅
  divisorSheaf of the presentation divisor + cohomologous-cocycle transport. Staged
  behind it: the rigid engine's rank export and the sheaf-level `hfib` discharge
  (`RigidEngine4Assembly.lean:53-56` stays complex-form; ledger `5d490ad95`).

What the Wave-4 datum campaign hands Wave 6 when it closes: `JacobianData C` (`J`,
`rep`, lft/qc certificates), Div^g-lite (DAT-D), the Σ-charts (h⁰=1 canonical-section
opens, single openness mechanism `rigidEngine_isOpen_vanishing`,
`RigidEngine4Assembly.lean:441`), coverage (DAT-B), and Speiser datum-descent (DAT-G —
descends *the datum*, not morphisms). Status at recon time: **all engine inputs landed**
(pic0Functor, RE-0..4, FLV, full degree lane — ledger `6bd5c9dca`, `5d490ad95`,
`5c71c4ce5`), **thirteen of sixteen DAT bricks unlanded** *(corrected same day against
the ledger — the original "all sixteen unlanded" was already false at write time)*:
LANDED are DAT-0a (P5-uniform H¹-vanishing bound,
`RiemannRoch/UniformVanishing.lean`, ledger `81c15870c`), DAT-4 (degree seam,
`Picard/DegreeSeam.lean`, ledger `7567a87e5`), and DAT-0b (Θ-positivity,
`RiemannRoch/ThetaDegree.lean`, ledger `a0aabaa37`); additionally DAT-2's gluing core
is in-tree standalone-green (`Picard/Pic0ZariskiSheaf.lean`, ledger `5d9cc9153` —
wiring, separation, and the S-lemma still open) and DAT-1 has a frozen spec only
(`informal/spec-dat-1.md`, ledger `64e77e1aa`, no code). No DAT brick produces
Albanese-specific mathematics.

## 2. Port inventory

Freshness rule: the in-tree copies (old AJC) are strictly ahead of the subproject —
6 files byte-identical, `AlbaneseUP.lean`/`CodimOneExtension.lean` in-tree-newer, and 5
Milne-3.3 machinery files exist in-tree only. **Recommendation (for the design pass):
port from `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/`** throughout
(exception: AlbaneseUP §0/§0.0, see the DO-NOT-PORT subsection below). Sorry counts
re-measured 2026-07-16:
subproject Albanese/ dir = 8 code sorries (AlbaneseUP ×7 at 183,250,300,335,373,417,458;
CodimOneExtension ×1 at 1721); in-tree = 7 (AlbaneseUP ×6 at 375,425,460,498,542,583 —
`bundle` closed by old-draft wiring; CodimOneExtension ×1 at 1752). Roadmap/handoff
counts ("17", "12") are stale.

### Sorry-free pure-algebra bricks (PORTABLE-AS-IS, verbatim file drops)

| File (in-tree Albanese/) | Lines | Imports | Contents |
|---|---|---|---|
| `AuslanderBuchsbaum.lean` | 3219 | **Mathlib only** | `Module.depth` (Stacks 00LF), `depth_eq_smallest_ext_index` (00LP), `depth_of_short_exact` (00LE), `auslander_buchsbaum_formula` (090V), `CohenMacaulay` class + `of_regular` (00OD), `isDomain_of_regularLocal` (00NP). Header prose claiming remaining sorries is stale — zero code sorries. Fills genuine Mathlib gaps at pin `fabf563a7c`. |
| `CoheightBridge.lean` | 236 | Mathlib only | `Scheme.ringKrullDim_stalk_eq_coheight`, `coheight_eq_of_isOpenEmbedding`, `coheight_spec_eq_height_primeSpectrum`, `ringKrullDimLE_of_coheight_eq_one`. Generic over any scheme; the Rebuild's stalk/DVR lane could consume it independently of Wave 6. |
| `StandardSmoothDimension.lean` | 215 | Mathlib only | `MvPolynomial.height_eq_natCard_of_isMaximal`, `natCast_le_height_of_isMaximal`, `IsRegularLocalRing.of_finrank_cotangentSpace_le_ringKrullDim`. |
| `SmoothPrimeRegularity.lean` | 768 | + StandardSmoothDimension | Serre-free Stacks-00TT route; `rank_kaehlerDifferential_eq_trdeg` over any **perfect** field; capstone `isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`. |
| `PolePurity.lean` | 616 | + AB, CoheightBridge | Milne-3.3 substep 4a, Serre/UFD-free: capstone `Scheme.exists_specializes_coheight_eq_one_of_notMem_stalk_range` (pole of a function-field element seen at a coheight-1 specialization). Abstract Scheme-level. |
| `RationalMapPrecomp.lean` | 176 | Mathlib only | `Scheme.RationalMap.precomp` along an open map + `precomp_compHom`, `le_domain_precomp`. |
| `RationalMapProd.lean` | 251 | Mathlib only | Relative product of rational maps over a base (`RationalMap.prod`, `le_domain_prod`, `prod_compHom_*`). |
| `RationalMapFunctionField.lean` | 121 | Mathlib only | `stalkPullback`, `functionFieldPullback` — K(Y)→K(X) along a dominant rational map (Milne-3.3 substep 3 bridge). |
| `DifferenceMap.lean` | 379 | + RationalMapPrecomp, RationalMapProd (siblings) | `diff : G ⊗ G ⟶ G` in any cartesian monoidal category, `isOpenMap_pullback_{fst,snd}_self` for smooth X, `differenceRationalMap` (Milne's Φ(x,y)=φ(x)φ(y)⁻¹) + `differenceRationalMap_compHom_over` (DifferenceMap.lean:81,182,197). Conventions already match the Rebuild. |
| `Milne33Substeps.lean` | 266 | siblings | Substep-2 topology (`exists_snd_mem_of_fst_eq_of_mem`, `exists_mem_domain_precomp_fst_of_differenceRationalMap`) + substep-4b transport (`Scheme.exists_specializes_coheight_eq_one_of_mem_maximalIdeal`). |

### Geometry layer

- **`CodimOneExtension.lean`** (in-tree 1799 L, 1 sorry) — **PORTABLE-WITH-REWORK
  (light)**. Fully proved: Milne Thm 3.1 (`indeterminacy_codimGe2_of_smooth_of_complete`
  via DVR stalk `localRing_dvr_of_codim_one` + Mathlib valuative criterion +
  `PartialMap.ofFromSpecStalk` spreading), `existsUnique_hom_of_indeterminacyLocus_eq_empty`,
  `hom_ext_of_toRationalMap_eq`, `isReduced_of_smooth_of_isAlgClosed`, in-tree
  `isIntegral_pullback_self`. The single sorry is **Milne Lemma 3.3**
  (`indeterminacy_pure_codim_one_into_grpScheme`, in-tree decl :1692, sorry :1752): substeps 1, 2-easy,
  4a, and 4b-pieces are closed by the sorry-free bricks above; **open**: substep 2-hard
  ((x,x) ∈ Dom(Φ) ⟹ x ∈ Dom(f)), substep 3 (Φ*-pullback of 𝒪_{G,e}), final assembly.
  Rework: drop the `WeilDivisor` import (**prose-only** — `PrimeDivisor`/`order` appear
  only in comments), severing the sole old-draft RiemannRoch dependency; decide k̄ vs k
  pinning. Documented historical trap to preserve: the former "CodimOneFree ⟹
  extension" lemma was **false** (ℙ² ⇢ ℙ¹ counterexample); the honest chain runs
  through `Z(f) = ∅`.
- **`Thm32RationalMapExtension.lean`** (337 L, **0 code sorries** — the 5 grep hits are
  prose) — **PORTABLE-AS-SHAPE, near drop-in**: `extend_to_av` (:309) = Milne I 3.2,
  fully written proof (AV integrality + Milne 3.3 disjunction vs Milne 3.1 ⟹ Z(f)=∅ ⟹
  extension). Axiom-clean conditional only on the Milne-3.3 sorry upstream. Imports
  Mathlib + CodimOneExtension only.

### Shape layer

- **`AlbaneseUP.lean`** (in-tree 664 L, 6 sorries) — **PORTABLE-AS-SHAPE**. Namespace
  `AlgebraicGeometry.Pic0`, headline `albanese_universal_property` (:645), statement
  shape-identical to `exists_unique_ofCurve_comp` restricted to k̄. Port the six
  def/theorem shapes + the sorry-free 4-line headline assembly (from
  `descentThroughBirationalSigma` :534 + `albanese_eq_iff_symmetricPower_eq` :574) with
  renames `jacobianScheme C` ↦ `Jacobian C`, `abelJacobi` ↦ `Jacobian.ofCurve`, old
  `genus` (used opaquely, as the ℕ index of `SymmetricPower` and in `0 < genus C`) ↦
  Rebuild `genus` (Challenge.lean:89). Preserve the instance-hygiene pattern: the four
  AV attributes of the Jacobian deliberately demoted from `instance` to def/theorem to
  stop silent `sorryAx` propagation — relevant exactly while Wave-5 instances are
  still sorried pins. The three in-tree §0.0 bridges are worth extracting on their own:
  `isReduced_of_flat_of_surjective` (:166), `geometricallyReduced_of_smooth` (:189) —
  but check first against the Rebuild's landed `Smooth.geometricallyIntegral`
  (`Curve/GeometricallyReduced.lean:153`), which likely subsumes the consumer —
  and `hasRationalPoint_of_isAlgClosed` (:224, targets the old-draft
  `Scheme.HasRationalPoint`; needs a Rebuild-native restatement).

### DO-NOT-PORT (recommendation — to be ratified by the Wave-6 design pass)

- In-tree AlbaneseUP **§0/§0.0 `bundle` wiring** (:293-308 region): reads off old-draft
  `Scheme.Pic0Scheme` / `Scheme.Pic0.{grpObj,proper,smooth,geometricallyIrreducible}`
  via `Pic0AbelianVariety` → `IdentityComponent` → FGA `HasPicScheme` — with
  `Pic0.smooth`/`Pic0.proper` still sorried in the old draft and `instHasPicScheme` the
  representability sorry. The Rebuild's Challenge.lean pins (`Jacobian C` + four
  instances) make the whole `Bundle`/`jacobianScheme` placeholder layer unnecessary.
- Old-draft Picard cone (`FGAPicRepresentability`, `Pic0AbelianVariety`,
  `IdentityComponent`): exactly the architecture the Rebuild replaced with
  pic0Functor/PicEtAff/degAff.
- Subproject `RiemannRoch/WeilDivisor.lean`, `Genus0BaseObjects/*`,
  `Cohomology/StructureSheafModuleK*`, `Genus.lean`: compile-substrate for the
  extraction only; the Rebuild has its own divisor/degree/cohomology stacks.

### Port order implied by the dependency DAG

AB → CoheightBridge → StandardSmoothDimension → SmoothPrimeRegularity → PolePurity, plus
RationalMap{Precomp,Prod,FunctionField} (all drop-in, parallelizable) → CodimOneExtension
+ DifferenceMap + Milne33Substeps → Thm32RationalMapExtension → AlbaneseUP shapes.

## 3. Gap map — Milne III.6.1 proof steps × {rebuild-has, portable, open}

| Step | Rebuild has (landed) | Portable from old work | Genuinely open |
|---|---|---|---|
| S1 Sym^g/C^(g) as a scheme + quotient UP | nothing; datum builds Div^g-lite instead (Sym^g explicitly "Not fired", `w4-datum-worksheet.md:305-307`) | **nothing** — the planned old SymmetricPower substrate file was never opened; `SymmetricPower` is a sorried opaque def | entire construction; OR a reworked S1-S4 through Div^g-lite (undecided, see §4) |
| S2 Abel maps f^P, f^{(g)} | `graphPicClass` + base-change law (`Curve/GraphDivisor.lean:245,263`); `LocalEquations.picClass` | AlbaneseUP shapes only (`abelJacobi` is a sorry) | `abelElement` (G-D8, degree lane); relative Abel correspondence (DAT-A) |
| S3 birationality of f^{(g)} (Thm 5.1a) | χ/RR ledger: `exists_effective_of_picClass` (FLVClass.lean:208), `peel_effective` (:292), FLV class form (:360), rank anchor `h0_eq_deg_add_chi_...` (:412) | nothing (old `descentThroughBirationalSigma` defers it into its sorry) | Milne 5.2(a) **strict** generic h¹-drop (Milne proves it via Serre duality — source read this pass, PDF pp. 107-108, see §4.4 for provenance; deferred by route item 7; tree has only the monotone direction); separability/Ω¹ leg (Prop 5.3, same provenance note) |
| S4 symmetric-sum factorization ψ : J ⇢ A | GrpObj sum vocabulary (Mathlib) | shape (`symmetricPowerAVMap`, `symmetricPowerToJacobian` — both sorries) | everything (needs S1, S3) |
| S5 extension: ψ regular (I 3.2 = 3.1 + 3.3) | only Mathlib `Scheme.RationalMap` spreading (`Curve/RationalToP1.lean`) | **the big win**: Milne 3.1 PROVED, extension-from-∅ PROVED, `extend_to_av` PROVED-mod-3.3, 3.3 substeps 1/2-easy/4a/4b-pieces PROVED (see §2) | Milne 3.3 substep 2-hard, substep 3, assembly (the one inherited sorry) |
| S6 ψ ∘ f^P = φ | — | biconditional shape (`albanese_eq_iff_symmetricPower_eq`, a sorry) | proof (bookkeeping given S2/S4) |
| S7 pointed ⟹ homomorphism (I 1.2) | **LANDED, k̄ only**: `isMonHom_of_isProper_of_geometricallyIntegral` (`RigidityCorollaries.lean:66`) on rigidity (`Rigidity.lean:184`), kernel-green, ledger `e21e41580`; + `Smooth.geometricallyIntegral` (`GeometricallyReduced.lean:153`) | nothing needed | consuming it at `J_{k̄}` needs Wave-5 instances transported to k̄ |
| S8 uniqueness (W^g = J surjectivity) | functor-level coverage = DAT-B (specced, unlanded), fed by FLVClass.lean:360 | old proof defers into `descentThroughBirationalSigma`'s sorry (reduced-separated agreement on a dense open is proved there-adjacent via `hom_ext_of_toRationalMap_eq`, portable) | connecting DAT-B coverage to the "sum of g curve points" form |
| S9 plain-morphism upgrade | mechanism landed (S7) + pointedness calc pinned (`route-decision.md:95-99`); needs `comp_ofCurve` (G-D8-fed) | n/a (old target already quantified over plain morphisms — same ∃! plumbing ports) | — |
| S10 k̄→k descent | **nothing** — `Descent/` is module/cocycle-level Amitsur; DAT-G descends the datum, not morphisms | **nothing** — the extension/UP layers that would matter for descent (CodimOneExtension, Thm32RationalMapExtension, AlbaneseUP) are `[IsAlgClosed kbar]`-pinned; the field-generic algebra/rational-map bricks carry no descent content | whole step: finite-level spreading + Milne-6.4 uniqueness-first Galois argument + the `(Jacobian C)_{k̄}` ≅ representing-object comparison |
| S11 genus 0 (Milne assumes g>0; frozen target does not) | — | nothing (old headline carries `0 < genus C` as a hypothesis — the Rebuild target CANNOT) | `Jacobian C ≅ 𝟙_` for g=0 + Milne I 3.9 (rational maps ℙ¹ ⇢ A constant); unscheduled anywhere |

## 4. Honest risks / open questions

1. **The C^(g)-vs-Div^g-lite fork is undecided and is the biggest design question for
   Wave 6.** Route item 16 assumed `Div^r ≅ C^(r)` shared with Wave 4; the binding
   datum worksheet bypasses Sym^g entirely (rejected as Plan-B RED fallback). Wave 6
   must either (a) build C^(g) native (route sizes it [S-RG]; zero material anywhere to
   port) or (b) rework Milne's S1/S3/S4 to run on Div^g-lite + Σ-charts directly —
   plausibly cheaper since DAT-B/D deliver the h⁰=1 charts and coverage, but nobody has
   written that argument down. Note (2026-07-16 correction pass): DAT-D's declared
   dependency DAT-0a is already closed (`RiemannRoch/UniformVanishing.lean`, ledger
   `81c15870c`; see §1.3) and the colength dictionary landed earlier (ledger
   `2db125308`) — of DAT-D's four declared deps (`w4-datum-worksheet.md:456`) only
   DAT-1 (spec frozen, no code) and DAT-A remain open. Recommendation (for the design
   pass): the AlbaneseUP port should NOT be started before this
   fork is decided: its `SymmetricPower`-shaped middle three bricks are exactly what
   would change.
2. **The old headline's hypothesis set is weaker than the frozen target.** Old:
   `[IsAlgClosed kbar]` + `0 < genus C`. Frozen: arbitrary `k`, no genus hypothesis.
   The port gives at best the k̄, g>0 core; S10 and S11 are new mathematics with zero
   portable or landed support. S10 additionally needs the base-change comparison
   `(Jacobian C)_{k̄} ≅` representing object over k̄ — mechanism exists
   (`RepresentableBy.uniqueUpToIso`, Wave-7 `baseChangeIso`, Wave-5 item 15), but its
   staging at the *non-finite* extension k̄ (vs only finite Galois levels + a
   spreading-out argument) is pinned nowhere.
3. **Milne 3.3 remains a genuine [RG] mountain even after the port.** The port hands
   over substeps 1, 2-easy, 4a, 4b-pieces sorry-free, but 2-hard (the diagonal
   argument), 3 (the 𝒪_{G,e}-pullback/function-field bridge past
   `functionFieldPullback`), and the assembly were open when the old lane stopped and
   have no new support in the Rebuild.
4. **Strict generic h¹-drop (Milne 5.2a) collides with the route's Serre-duality
   deferral.** *Provenance*: the Milne III §5 proof content below was READ this pass
   (2026-07-16) from `references/abelian-varieties.pdf`, PDF pp. 107-109 (doc
   pp. 101-103). **No workspace transcription covers it yet** — `references/
   abelian-varieties/tex/` holds only pp. 14-15 (I §1 rigidity), the contents map
   `references/abelian-varieties.md` is section-level, and the old-AJC blueprint's
   SOURCE QUOTE reaches only the Thm 5.1(a) STATEMENT + preceding paragraph — so
   transcribe PDF pp. 107-110 (the III.6.1 statement/proof skeleton on p. 110, read
   for §1.2, is equally untranscribed) before the design pass leans on the details. Read
   content: Lemma 5.2(a) (h¹(D)>0 ⟹ h¹(D+Q) = h¹(D)−1 for Q in a nonempty open
   U ⊆ C, unchanged off U) is proved via Serre duality
   `H¹(C,L(D+Q))^∨ = Γ(C,Ω¹(−D−Q))` ⊆ Γ(Ω¹(−D)); 5.2(b) (generic h⁰(ΣPᵢ)=1, r ≤ g)
   iterates (a) from h¹(0)=g and closes with Riemann–Roch; the proof of Thm 5.1(a)
   uses 5.2(b) for injectivity on an open, leaving "birational or purely inseparable
   of degree > 1", with inseparability excluded via Thm 5.1(b), whose proof needs
   Prop 5.3 (canonical isos `Γ(C,Ω¹) ≅ Γ(C^r,Ω¹)^{S_r} ≅ Γ(C^{(r)},Ω¹)` and
   `f^{(r)*} : Γ(J,Ω¹) ≅ Γ(C^{(r)},Ω¹)`). The route defers duality "until a consumer
   forces it" and the FLV worksheet rejected the duality route. Either Wave 6 is that
   forcing consumer (a mountain), or a duality-free argument for generic
   h⁰(P₁+…+P_g)=1 must be designed on the landed χ/peel ledger (only the monotone
   direction exists today, FLVClass.lean:292). The separability leg (Prop 5.3, Ω¹
   comparison) similarly has no landed differential machinery — nearest adjacent is
   Wave-5's planned `T₀Pic ≅ H¹(C,𝒪)`.
5. **Sequencing dependency**: Wave 6's statement consumes `ofCurve`/`comp_ofCurve`
   (G-D8, degree lane) and Wave-5 instances on `Jacobian C` — none started. Porting the
   pure-algebra + rational-map bricks (§2) is the only Wave-6-directed work that is
   unblocked *today*; it is also zero-risk (Mathlib-only imports, identical pin).
6. **Trust the files, not the prose.** Old headers/roadmaps carry stale sorry counts
   (AB's header claims sorries it no longer has; roadmap says 12 vs actual 7 in-tree)
   and a stale headline name (`Scheme.Pic.albaneseUP` in the old README vs actual
   `AlgebraicGeometry.Pic0.albanese_universal_property`). All counts in this recon were
   re-measured 2026-07-16.
