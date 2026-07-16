# Wave-5 reconnaissance — the `Pic⁰` abelian-variety package (`AJCR` Wave 5)

*Read-only recon, 2026-07-16, produced by the parallel (non-prover) session. This worksheet is
RECON for the primary session's Wave-5 design pass: it maps ground truth and stakes out candidate
bricks and risks; it makes **NO binding design decisions** — route choices flagged below (P-A/P-B/P-C,
GI-(a)/(b), S-α1/α2, brick cuts) are candidates reserved to the design pass. Every landed-name claim
carries `file:line`; Lean-side claims were re-verified this session against the tree at ledger
commit `5c71c4ce5` (head at recon time; the ledger has since moved) and the pinned mathlib checkout (`.lake-packages/mathlib`, v4.31.0,
`fabf563a7c95a...`). Paper citations (Kleiman/Milne/Mumford/Stacks) are relayed from the math-route
reader's same-day reading session and carry that reader's READ/UNREAD flags. No file outside
`informal/` was touched; no build or lake-locking tool was run. The tree moves under this document:
trust the ledger and the files over any prose here.*

Wave 5 = discharge the three frozen instances on `J := Pic⁰` (route-decision §1), on the pinned
curve-specialized-Kleiman route: `Jacobian.smoothOfRelativeDimension_genus` (`Challenge.lean:112`),
`Jacobian.instIsProper` (`:116`), `Jacobian.instGeometricallyIrreducible` (`:120`); protected names
per `archon-protected.yaml:22-24`.

---

## 0. Headline

- **What Wave 5 actually requires.** Three Prop-instances on the structure morphism of the (not yet
  constructed) representing scheme: `SmoothOfRelativeDimension (genus C) (Jacobian C).hom`,
  `IsProper (Jacobian C).hom`, `GeometricallyIrreducible (Jacobian C).hom` — provable from the
  curve bundle `{k}[Field k]{C}[Smooth1][IsProper][GeomIrr]` plus the earlier frozen declarations
  only, **no rational point available** (`Challenge.lean:57-63,110-121`). All statements must be
  phrased against the pinned Wave-4 seam `(d : JacobianData C)` — `d.J`, `d.rep`,
  `d.locallyOfFiniteType`, `d.quasiCompact` — since the frozen discharge
  `Jacobian C := (jacobianData C).J` is definitional (w4-datum-worksheet §1.1/§1.4, BINDING per
  ledger `7f4fec1e3`). **`JacobianData` is not yet in the Lean tree** (grep this session: zero
  hits outside `informal/`), so all Wave-5 work today is stateable only with the datum as a section
  variable — which the binding consumption header prescribes anyway.
- **The biggest gap** is a double one, one per hard target: (i) *smoothness assembly* — the tree
  has **zero** such machinery, and mathlib has **zero** scheme-level infinitesimal-smoothness,
  dual-number-tangent, fiber-dimension, or `Smooth`→`SmoothOfRelativeDimension n` machinery
  (ring-level `DualNumber` and `Algebra.FormallySmooth` exist, §2.7 gifts; grep-verified §2.7/§2.8; no
  `SmoothOfRelativeDimension` descent instance exists either — checked this session against
  `Morphisms/{FlatDescent,LocalFlatDescent}.lean`, zero hits), so the route from
  `T₀J ≅ H¹(C,𝒪)` to the frozen numeral-`genus C` instance is genuinely greenfield; and (ii)
  *universal closedness* — every candidate properness route needs either two mathlib-absent
  commutative-algebra mountains (DVR-refined valuative criterion + Auslander–Buchsbaum
  regular-local⇒UFD; both re-verified absent, §2.7) or the `Div^d`/`C^{(d)}` proper scheme + Abel
  morphism, which is Wave-4/6-shared infrastructure not yet built.
- **The biggest asset** is the landed convergence of three stacks: (a) the mathlib group-scheme
  gifts — `smooth_of_grpObj` (`Group/Smooth.lean:64`) kills the deformation half of smoothness,
  `IsClosedImmersion η[G].left` (`Group/Abelian.lean:35`) + `GrpObj.mulRight` (`Grp.lean:275`)
  power separatedness and translation homogeneity; (b) the project's complete degree/χ/FLV/rigid
  engine (§2.3–2.5), which already contains every cohomological ingredient of the
  symmetric-power properness/irreducibility routes (`riemann_inequality_curve`, `fiberTwist`,
  `classDeg` base-field invariance, `rigidEngine_isOpen_vanishing`); (c) a large **sorry-free
  old-draft tangent-space kit** (five files, mathlib-only imports, §2.8) whose port is mostly
  namespace surgery.
- **One route asymmetry worth stating up front** (not deciding): properness route P-B / geometric
  irreducibility route GI-(a) share one substrate (`C^{(d)} ↠ J` at every field point) and consume
  only landed clauses of the engine; the competing routes (P-A valuative-with-divisor-closure,
  GI-(b) χ-local-constancy) each require a named mathlib-absent brick or a recorded Mumford-II.5
  re-entry. §3/§5 lay out the evidence; the design pass decides.

---

## 1. Staleness / context audit — what the binding docs already say about Wave 5, and what moved

### 1.1 `route-decision.md` §4, Wave-5 items 13–15 (route-decision.md:159-170) — STILL THE PIN, one budget line already answered

Verbatim content (re-read this session): item 13 — tangent space `T₀Pic = H¹(C,𝒪)` (dual numbers,
truncated exponential) [S]; smoothness via geometric reducedness at 0 + `smooth_of_grpObj` [S];
`SmoothOfRelativeDimension (genus C)` assembly [S]. Item 14 — properness [RG]: valuative
criterion; extend a line bundle on `C_K` over `C_A` (`C_A` regular 2-dimensional ⇒ locally
factorial — "needs an Auslander–Buchsbaum-grade brick; budget explicitly, consider the
`C^(g)`-surjection alternative if Sym^g lands first for Albanese"). Item 15 — geometric
irreducibility via identity-component theory `lem:agps(3)` [S], "this single lemma also powers
`baseChangeIso`".

Staleness findings:
1. **Item 15's last sentence is superseded by the design's own D7** (wave3-picard-design.md:31 and
   §6.3 at :786-790, re-read this session): `baseChangeIso` does **not** consume identity-component
   theory — the degree-0 condition is E-iv-stable under the shuffle directly. `lem:agps(3)` is a
   Wave-5-only input *if used at all*; and §6.3 offers route (a) (`C^{(g)} ↠ Pic⁰`) which avoids
   it entirely (§3.3 below).
2. **Item 14's "budget explicitly" is now answerable with evidence**: the Auslander–Buchsbaum brick
   is confirmed absent from the pinned mathlib (`RingTheory/RegularLocalRing/` contains only
   `Defs.lean`, checked this session), the valuative criterion exists only over arbitrary valuation
   rings (`IsProper.of_valuativeCriterion`, `ValuativeCriterion.lean:339`) with **no DVR
   refinement**, and fppf descent of `IsProper` does not exist (`DescendsAlong` instances limited to
   `FlatDescent.lean`/`LocalFlatDescent.lean`, neither covers `IsProper`/`IsSeparated`). The
   parenthetical alternative (`C^(g)`-surjection) has meanwhile gained assets: `fiberTwist` +
   `classDeg_fiberTwist` (`RiemannRoch/FiberTwist.lean:301,393`) and `riemann_inequality_curve`
   are landed, and mathlib's `UniversallyClosed.of_comp_surjective`
   (`Morphisms/UniversallyClosed.lean:77`) is exactly the image-argument gift.
3. **Item 13's [S] tags are optimistic in one place**: the "`SmoothOfRelativeDimension (genus C)`
   assembly [S]" has no mathlib substrate at all (§2.7 absences) — see risk R3.

### 1.2 `wave3-picard-design.md` §5 + §6.3 — the seam and the fence, both intact

- §5's "What is deliberately NOT stored" (:643-644, re-read): separatedness of `J.hom` ("Wave 5
  derives it group-theoretically: Kleiman `lem:agps`(1) — diagonal = `α⁻¹(e)`"), geometric
  properties of `J`, all smoothness/properness data — Waves 5's own mountains, consuming `rep` +
  the certificates only. Still exactly the contract; nothing landed contradicts it.
- §6.3 (:770-790, re-read in full): `J` is *defined* by the degree-0 functor; "`J = (Pic)⁰`" is
  internal to Wave 5 and needed **only** for `GeometricallyIrreducible`. Two connectedness routes
  on record: (a) `C^{(g)} ↠ Pic⁰` over `k̄` ("expected cheaper given Sym^g lands for Albanese
  anyway"); (b) χ/degree local-constancy in flat families + finiteness of components ("needs the
  Wave-4 pushforward engine"). **What changed since**: the w4-rigid-engine worksheet has since
  *descoped* the II.5-full clauses that route (b) needs — (b) is now the named re-entry consumer
  (§1.4, §5 R6). `lem:agps`(3) "applies to `J_k̄` once it knows `J` is connected" — i.e. it is
  packaging, not the connectedness source, on either route.

### 1.3 `w4-datum-design.md` + `w4-datum-worksheet.md` (BINDING, ledger `7f4fec1e3`) — the datum seam Wave 5 consumes

- The datum shape is pinned and typing-verified against the checkout (worksheet §1.1, :59-75,
  re-read verbatim this session): `structure JacobianData C … where J : Over (Spec (.of k));
  rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J;
  locallyOfFiniteType : LocallyOfFiniteType J.hom; quasiCompact : QuasiCompact J.hom`. The
  Wave-5 consumption row (:144, re-read): the three targets consume "`rep` + the two certificates
  (properness = qc + lft + separatedness + valuative; separatedness group-theoretic per design
  §5)". **Caveat carried from the math-route reader and endorsed here: that parenthesis is
  Wave-4-designer prose, not a Wave-5 route decision** — "valuative" names one of three candidate
  universal-closedness routes (§3.2).
- `w4-datum-design.md` w4-4 (:336-343, re-read): under the default FLV route `QuasiCompact J.hom`
  is recovered "a posteriori from qc of the Abel source (image of a qc scheme)" — the certificate's
  Wave-4 provenance may shift but the field shape is fixed. Wave 5 should treat `d.quasiCompact`
  as opaque.
- **What moved under these docs since they were written: only in Wave 5's favour.** Landed
  since/with them (ledger, re-verified): `pic0Functor`/`degAt`/`pic0Subgroup` (`6bd5c9dca`), the
  full rigid engine RE-0..RE-4 incl. openness + eq:Q + ring-map clause (`5d490ad95`), E-iv-alg
  degree base-field invariance (`8ef679217`), blueprint noding (`5c71c4ce5`, head at recon time). NOT landed:
  `JacobianData`/`jacobianData`, `abelElement` (G-D8; spec doc `6d1bd712e` landed, still zero `.lean` hits),
  RE-5, and the remaining DAT-* bricks — DAT-0a/0b, DAT-2 (engine + wiring), DAT-4, and DAT-1 (spec + brick
  (1a)) landed 2026-07-16 15:20-15:49 after this recon's pin; re-check the ledger at design time. So the datum seam
  exists on paper with its carrier functor landed, and Wave 5 can begin stating theorems against
  `(d : JacobianData C)` the moment the structure declaration itself lands (a Stage-A DAT brick).

### 1.4 `w4-rigid-engine-worksheet.md` — the Mumford II.5 descope boundary (BINDING)

Verdict-in-one-line re-read (:26-34): full Mumford II.5 (the universal finite-projective
Grothendieck complex, Lemma II.5.1) is NOT needed and is descoped; the honest curve-lite engine is
COH (coherence) + Nakayama openness + split/flat rigidity — i.e. Kleiman `sb:Q` 3.10 (v)⟹(i)+(iii)
on the vanishing locus, with base change on the nose there. Recorded re-entry path (:73, :522): if
a consumer demands "χ of a family as a locally constant function off the vanishing locus", that is
II.5.1's descending induction ON TOP of COH — an add-on brick, not a redesign. **Wave-5 relevance
(the descope boundary, stated once here and again as risk R6):** the engine deliberately does NOT
provide semicontinuity, the Exchange property, cohomology-and-base-change off the vanishing locus,
or χ-in-families — exactly the clauses that (i) Kleiman `prp:H2`'s verbatim proof of Pic-smoothness
and (ii) irreducibility route GI-(b) assume. Wave-5 routes must consume only the landed clauses
(§2.5) or explicitly queue the re-entry brick. Anchor status (updated 2026-07-16): the II.5 source
pages, book pp. 46-55, are now fully transcribed and citable as
`mumford-abelian-varieties:page-0057`..`page-0066` (manifest) — the re-entry's remaining cost is
the Lean add-on brick alone, no transcription task.

### 1.5 `deg-d5b-worksheet.md` §2 (D2) — the parked seam that lands in Wave 5

Re-read (:104-105): "the χ half of the recon's G11 (`h1_baseChange`, genus invariance) is out of
scope of this campaign: it is a Wave-5/ζ concern, consumed nowhere by degAt/pic0Functor/…". Wave 5
is the resurrection point: `H¹(C,𝒪) ⊗_k K ≅ H¹(C_{K},𝒪)` for field extensions is consumed by the
smoothness route's `k̄`-legs and by `dim T₀(J_k̄) = genus C`. Engine-grade (flat CBC on the
two-cover complex; the ring-map clause `RigidEngine4BaseChange.lean` is the landed pattern), NOT
II.5. Candidate brick W5-X2.

---

## 2. Exact API map (verbatim signatures + `file:line`; LANDED only unless marked)

Paths under `…/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/` unless prefixed. Tags:
**[landed]** = in the Rebuild tree, re-verified this session; **[mathlib]** = pinned checkout
v4.31.0, re-verified; **[old-draft-portable]** = sorry-free prior art in
`MainProjects/Algebraic-Jacobian-Challenge/` (READ-ONLY), port verdict folded in — every such item
must be re-kernel-verified on port (the old draft has a documented falsely-marked-proved incident
and a never-compiled-inheritance repair, ledger `2918d0235`).

### 2.1 Frozen targets + the Wave-4 datum seam

```lean
-- Challenge.lean (frozen; section vars :57-63 = {k}[Field k]{C}[Smooth1 C.hom][IsProper C.hom][GeomIrr C.hom])
noncomputable def genus (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] : ℕ :=
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)                          -- :89-92 [landed, sorry-free]
noncomputable def Jacobian (C : …) : Over (Spec (.of k)) := sorry                     -- :96-99  (Wave 4)
noncomputable instance instGrpObj : GrpObj (Jacobian C) := sorry                      -- :107-108 (Wave 4)
instance smoothOfRelativeDimension_genus :
    SmoothOfRelativeDimension (genus C) (Jacobian C).hom := sorry                     -- :112-113 ★ TARGET 1
instance : IsProper (Jacobian C).hom := sorry                                         -- :116-117 ★ TARGET 2 (instIsProper)
instance : GeometricallyIrreducible (Jacobian C).hom := sorry                         -- :120-121 ★ TARGET 3 (instGeometricallyIrreducible)
```

Protected names for the two anonymous instances: `AlgebraicGeometry.Jacobian.instIsProper`,
`…instGeometricallyIrreducible` (`archon-protected.yaml:22-24`). Note `exists_unique_ofCurve_comp`
(`:141-147`, Wave 6) binds competitor abelian varieties as `[Smooth A.hom]` — mathlib plain
`Smooth`, not rel-dim; Wave 5's targets are the *supplier* of those hypotheses for `J` (§2.2 end).

The seam (pinned, NOT yet Lean): `JacobianData C` with fields `J`, `rep`, `locallyOfFiniteType`,
`quasiCompact` (w4-datum-worksheet.md:67-75 verbatim; grep this session: `JacobianData` has zero
Lean-tree hits; `RepresentableBy` appears only in the `Pic0Functor.lean:29` docstring). Binding
consumption header for Wave-5 files (design §5): section variable `(d : JacobianData C)`,
`attribute [local instance] JacobianData.grpObj`, statements phrased about `d.J`; discharge at the
frozen gate is `exact theorem_x … (jacobianData C)` once Wave 4 lands the producer.

```lean
def pic0Functor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u} where …                    -- Picard/Pic0Functor.lean:151 [landed]
def pic0Subgroup (T : Over (Spec (.of k))) : Subgroup (picEt C T) where …             -- :107  (membership: ∀ K [Field K] [Algebra k K] t, degAt lam t = 0; mem_pic0Subgroup_iff :121)
def degAt {T} (lam : picEt C T) {K} [Field K] [Algebra k K] (t : overSpec k K ⟶ T) : ℤ -- :54
theorem degAt_picEtMap (f : T' ⟶ T) (lam) (t') : degAt (picEtMap C f lam) t' = degAt lam (t' ≫ f) -- :87
def pic0Inclusion : pic0Functor C ⟶ picEtFunctor C                                    -- :176 (naturality := rfl)
```

### 2.2 Rigidity layer — [landed], and NOT needed for Wave 5's own three targets

- `exists_unique_eq_snd_comp_of_isProper_of_geometricallyIntegral` (Mumford Form-I rigidity),
  `AbelianVariety/Rigidity.lean:184` **[landed]**; over `[IsAlgClosed K]` only (variable block
  above it). Supporting: `point_ext_of_apply_closedPoint_eq` `:151`, instance
  `isIntegral_tensorObj_left` `:160` (product of geometrically integral lft schemes over a field
  is integral — GI route (a) consumes this).
- `isMonHom_of_isProper_of_geometricallyIntegral` (Milne I 1.2 avatar),
  `AbelianVariety/RigidityCorollaries.lean:66` **[landed]**.
- Role inversion to record: Wave 5 does not *consume* rigidity — commutativity of `J` is free
  (`pic0Functor` is `CommGrpCat`-valued; `d.rep` + `GrpObj.ofRepresentableBy` give a commutative
  group object by construction). Wave 5's three outputs are what make `J` a legal *input* of the
  rigidity layer (plus mathlib's `isCommMonObj_…` for competitors `A`) in Wave 6. The
  `[IsAlgClosed K]`-only scope of the landed rigidity is a Wave-6 descent problem, not Wave-5's.
- Bookkeeping bridge **[landed]**, `Curve/GeometricallyReduced.lean`: instance (prio 100)
  `Smooth.geometricallyReduced` `:130`; instance (prio 100) `Smooth.of_smoothOfRelativeDimension_one`
  `:140`; `SmoothOfRelativeDimension.geometricallyReduced (n)` `:147` (arbitrary `n`, not an
  instance — `n` not inferable); instance (prio 100) `Smooth.geometricallyIntegral` `:153`;
  `SmoothOfRelativeDimension.geometricallyIntegral (n)` `:159`; smoke tests
  `example : GeometricallyReduced C.hom := inferInstance`, `example : GeometricallyIntegral C.hom
  := inferInstance` `:173-174`. Consequence: once targets 1+3 land, `GeometricallyIntegral
  (Jacobian C).hom` is one explicit theorem application away —
  `SmoothOfRelativeDimension.geometricallyIntegral (genus C)` (`:159`); NOT instance resolution
  (`n` is not inferable from the conclusion, and the only instance bridge from rel-dim, `:140`,
  covers `n = 1` only) — which Wave 6 needs.

### 2.3 Pic⁰ / degree lane — [landed]

```lean
def relPic (T) : Type u := (C ⊗ T).left.CechPic ⧸ picFromBase C T                     -- Picard/RelPic.lean:63
def PicEtAff (A) : Type u  (one-step étale plus at affine tests)                       -- Picard/PicEtAff.lean:218
theorem PicEtAff.unit_injective [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom] :
    Function.Injective (PicEtAff.unit C A)                                             -- Picard/CechKernelLemma.lean:361  (C1; arbitrary k-algebra A; the three curve-side
                                                                                       --   instances are discharged by the standing bundle — GeomReduced from Smooth1 via
                                                                                       --   Curve/GeometricallyReduced.lean:130/:140. NOT Picard/EtaleSeparatedness.lean:
                                                                                       --   that file is a stub assembly holding only ζ1 (tensorInl/tensorInr,
                                                                                       --   cechPicMap_tensorInl_eq_tensorInr); its docstring merely restates the theorem)
theorem PicEtAff.unit_surjective_of_section (σ : overSpec k K ⟶ C) :
    Function.Surjective (PicEtAff.unit C K)                                            -- Picard/EffectivityClose.lean:141  (C2; FIELD tests WITH a curve section only)
noncomputable def PicEtAff.unitEquiv_of_section (σ) : relPic C (overSpec k K) ≃* PicEtAff C K -- :186
def picEtAffineEquiv : picEt C (overSpec k A) ≃* PicEtAff C A                          -- Picard/PicEt.lean:235
noncomputable def picEtFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}              -- Picard/PicEtMap.lean:314
-- degree stack
noncomputable def classDeg : Additive X.CechPic →+ ℤ                                   -- RiemannRoch/Degree.lean:150 (E-i classDeg_picClass :157, E-ii classDeg_mul :164)
noncomputable def relPicDeg (K) [Field K] [Algebra k K] : …                            -- RiemannRoch/RelPicDegree.lean:61 (+ relPicDeg_relPicAlgMap, E-iv-alg descended)
theorem classDeg_cechPicMap_baseFieldTransition (φ : K₁ →ₐ[k] K₂) : …                  -- RiemannRoch/DegreeBaseFieldInvariance.lean:462 (E-iv-alg keystone)
def PicEtAff.degAff (K) : PicEtAff C K → ℤ                                             -- Picard/DegreeZero.lean:263 (value pinned by degAff_mk; degAff_unit = relPicDeg :314)
noncomputable def fiberTwist (n : ℕ) : Y.CechPic                                       -- RiemannRoch/FiberTwist.lean:301 (classDeg_fiberTwist :393 — the no-point degree shifter)
-- divisor gadgets (abelElement substrate, G-D8 = Wave 4's; listed as GI/properness adjacents)
noncomputable def diagonalPicClass [SmoothOfRelativeDimension 1 C.hom] : …             -- Curve/DiagonalEquations.lean:342
graphPicClass / graphLocalEquations_base_change                                        -- Curve/GraphDivisor.lean (docstring consumer note :242-244)
```

Key structural fact for the tangent seam (§3.1): the (C2) dictionary `relPic ≃* PicEtAff` is landed
**only for field tests carrying a curve section**; there is no unit surjectivity at any non-field
test (in particular none at `k[ε]`), and none at sectionless field tests. C1 injectivity is
unconditional over any `k`-algebra.

### 2.4 χ / FLV layer — [landed]

```lean
theorem chi_divisorSheaf (D : X.CurveDivisor) : …                                      -- RiemannRoch/ChiLedger.lean:109 (χ(𝒪(D)) = χ(𝒪_X) + deg K D)
chi_moduleKSheaf : χ(𝒪_C) = 1 − genus C ; chi_divisorSheaf_curve (RR-lite) ;
riemann_inequality_curve : deg D + 1 − genus C ≤ h⁰(𝒪(D))                              -- RiemannRoch/ChiCurve.lean:148,161,183
theorem subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1 …                        -- RiemannRoch/FLVVanishing.lean:302 (FLV, finite-map form)
theorem exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1 …           -- RiemannRoch/FLVClass.lean:360 (class form)
theorem h0_eq_deg_add_chi_of_subsingleton_hModule_one …                                 -- RiemannRoch/FLVClass.lean:412 (rank anchor h⁰ = deg + χ)
```

`riemann_inequality_curve` + `fiberTwist` are the exact "every degree-`d ≥ g` class has an
effective representative at every field point, no rational point needed" input of routes P-B/P-C
and GI-(a). Genus is *only* `Challenge.lean:89-92`; **no genus base-change invariance exists**
(deg-d5b parked it to Wave 5, §1.5).

### 2.5 Rigid engine (RE-0..RE-4) — [landed]; the clauses Wave 5 may consume

```lean
theorem isOpen_setOf_subsingleton_residueField_tensor [Module.Finite R M] : …           -- Cohomology/RigidEngine2Nakayama.lean:105 (THE one openness mechanism, Noetherian-free)
theorem rigidEngine [IsNoetherianRing R] … ; rigidEngine_isOpen_vanishing               -- Cohomology/RigidEngine4Assembly.lean:414,441
theorem relTwistRigidEngine [IsNoetherianRing R] …                                      -- Cohomology/RigidEngine4Engine.lean:174 (H¹=0 + H⁰ fin. proj. on the vanishing locus)
theorem relTwistRigidEngine_isOpen_vanishing : …                                        -- :194 (Noetherian-free)
noncomputable def relTwistH0TensorEquiv … ; relTwistH0BaseChangeEquiv …                 -- :206,:224 (eq:Q; ring-map clause)
theorem relTwistPairDiffBaseChange …                                                    -- Cohomology/RigidEngine4BaseChange.lean:412 (twisted δ-naturality; the CBC pattern W5-X2 reuses)
```

Staging note carried verbatim (Engine.lean:37-42 docstring + ledger `7f4fec1e3`): the fibre
hypothesis is consumed in COMPLEX form; the sheaf-level discharge and the rank export are frozen
as DAT-3 (Wave-4 cbc lane). Wave 5 must not silently assume them.

### 2.6 Curve substrate — [landed]

```lean
theorem exists_isFinite_isDominant_toP1 : ∃ π, IsFinite π ∧ IsDominant π ∧ π ≫ P1.structureMap k = C.hom -- Curve/MapToP1.lean:125
-- base-change instance stack for C_K (any field extension K/k):
instance instSmoothOfRelativeDimensionSndLeft / instIsProperSndLeft / … / instIsIntegralBaseChange -- Curve/BaseChangeInstances.lean:97,106,…,152 (doc list :38-46)
theorem Over.isIso_appTop_snd_overSpec : … (Γ((C ⊗ Spec A).left, 𝒪) = A, ∀ k-algebra A)  -- Picard/UniversalSections.lean:82
Over.sectionsBaseChange : Γ(C.left,V) ⊗[k] A ≃+* Γ(C_A, V_A) (qcqs V, any k-algebra A)   -- Cohomology/SectionsBaseChange.lean (docstring :25 reserves it for "the dual-numbers tangent engine (A = k[ε])")
-- frozen-file base-change scaffolding (sorry-free): GeomIrr/Smooth1 stability under baseChange k L -- Challenge.lean:178-188
```

Greenfield certificate (grep this session, zero `.lean` hits in the Rebuild): `DualNumber`,
`TrivSqZeroExt`, `IdentityComponent`, `connectedComponent`, `valuative`, `FormallySmooth`. The
entire tangent, identity-component, and valuative lanes are unbuilt here.

### 2.7 Relevant mathlib — [mathlib] gifts and load-bearing ABSENCES (all re-verified this session)

Gifts:
```lean
lemma smooth_of_grpObj [GeometricallyReduced f] : Smooth f                              -- AlgebraicGeometry/Group/Smooth.lean:64
  -- context :30-31: {K}[Field K]{G}(f : G ⟶ Spec (.of K))[LocallyOfFiniteType f][GrpObj (Over.mk f)]
theorem isCommMonObj_of_isProper_of_geometricallyIntegral (G : Over (Spec (.of K)))
    [IsProper G.hom] [GeometricallyIntegral G.hom] [GrpObj G] : IsCommMonObj G          -- Group/Abelian.lean:133 (Stacks 0BFD)
instance (G : Over (Spec (.of K))) [GrpObj G] : IsClosedImmersion η[G].left             -- Group/Abelian.lean:35
def GrpObj.mulRight {A : C} [GrpObj A] (f : 𝟙_ C ⟶ A) : A ≅ A                           -- CategoryTheory/Monoidal/Grp.lean:275 (translation-by-a-point iso)
def GrpObj.ofRepresentableBy (F : Cᵒᵖ ⥤ GrpCat.{w}) (α : (F ⋙ forget _).RepresentableBy X) : GrpObj X -- CategoryTheory/Monoidal/Cartesian/Grp.lean:35
class IsProper : Prop extends IsSeparated f, UniversallyClosed f, LocallyOfFiniteType f -- Morphisms/Proper.lean:42 (qc implied: UC → QC instance, UniversallyClosed.lean:164)
lemma UniversallyClosed.of_valuativeCriterion [QuasiCompact f] …                        -- ValuativeCriterion.lean:236 (Existence half; stacks 01KF tag at :235)
lemma IsProper.of_valuativeCriterion [QuasiCompact f] [QuasiSeparated f] [LocallyOfFiniteType f] … -- ValuativeCriterion.lean:339
lemma UniversallyClosed.of_comp_surjective (f : X ⟶ Y) (g : Y ⟶ Z) …                    -- Morphisms/UniversallyClosed.lean:77 (image argument)
theorem Scheme.LocalRepresentability.isRepresentable / def representableBy              -- Sites/Representability.lean:207/192 (Stacks 01JJ; Wave 4's engine)
class GeometricallyIrreducible (f : X ⟶ Y) : Prop …                                     -- Geometrically/Irreducible.lean:42 (+ irreducibleSpace ascent :92, comp with UniversallyOpen :121)
class SmoothOfRelativeDimension … ; instance HasRingHomProperty (@SmoothOfRelativeDimension n) (Locally (IsStandardSmoothOfRelativeDimension n)) -- Morphisms/Smooth.lean:135,:154
lemma smoothOfRelativeDimension_isStableUnderBaseChange …                               -- Morphisms/Smooth.lean:166-170 (lemma, not instance)
DualNumber R := TrivSqZeroExt R R (+ ε, derivation/square-zero kit)                     -- Algebra/DualNumber.lean:46
Algebra.FormallySmooth (ring level; lifting criterion as theorems)                      -- RingTheory/Smooth/Basic.lean
```

ABSENT from the pinned mathlib (grep re-verified this session; each is a potential Wave-5 debt):
1. **Regular-local ⇒ UFD** (Auslander–Buchsbaum): `RingTheory/RegularLocalRing/` = `Defs.lean` only.
2. **DVR-refined valuative criterion** (criterion tested on DVRs/complete DVRs only): not in
   `ValuativeCriterion.lean`.
3. **fppf/fpqc descent of `IsProper`/`IsSeparated`**: `DescendsAlong` instances exist only for
   Surjective/UniversallyClosed/UniversallyOpen/UniversallyInjective/iso/OpenImmersion
   (`FlatDescent.lean:40-127`) and LocallyOfFiniteType/LocallyOfFinitePresentation/Smooth/
   FormallyUnramified/Etale (`LocalFlatDescent.lean:35-47`).
4. **Any `SmoothOfRelativeDimension` descent** along field extension or fpqc: zero hits in both
   descent files (checked this session). Whether the generic
   `HasRingHomProperty.descendsAlong_flat` (`FlatDescent.lean:156`) applies to
   `Locally (IsStandardSmoothOfRelativeDimension n)` is an open probe (risk R3).
5. **Scheme/fiber dimension theory** (`Scheme.dim`, fiber dim of smooth morphisms): absent; only
   Krull-dim primitives.
6. **Scheme-level `FormallySmooth` morphism class**, tangent-space-via-dual-numbers: absent.
7. **Identity components of group schemes** (`identityComponent`): zero Mathlib hits.
8. **Group-scheme separatedness lemma** (`IsSeparated` from `GrpObj` + `IsClosedImmersion η`):
   zero hits in `AlgebraicGeometry/Group/` (checked this session) — the `lem:agps`(1) brick is
   project work, small.
9. Scheme-level Picard theory, rigidity: absent (project owns both).

### 2.8 Old-draft portable kit — [old-draft-portable] (paths `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/`)

Sorry inventories re-verified this session (`grep -c sorry`; sorry *bodies* per the old-draft
reader): `Pic0DualNumberCocycle.lean`, `Pic0TangentSpace.lean`, `TangentSpaceIdentitySection.lean`
= **0 sorries**; `Pic0AbelianVariety.lean` = 3 sorry bodies (:672 reduced dimension core, :806
`smooth`, :826 `proper`); `IdentityComponent.lean` = 3 sorry bodies (:1460, :1501, :1527 — §1
substrate sorry-free). Encoding matches the Rebuild (`Over (Spec (.of k))` + `GrpObj`); systematic
deltas: old `GeometricallyIntegral` vs Rebuild `GeometricallyIrreducible` hypotheses, old bare
`Smooth` vs Rebuild `SmoothOfRelativeDimension (genus C)`, old `Scheme.HModule`/`AffineCoverMVSquare`
vs Rebuild `Sheaf.HModule`/`TwoCover` carriers (translation, not redesign).

| Unit | Verdict (from the old-draft reader, spot-checked) |
|---|---|
| 5-file tangent chain `DualNumberUnits` → `TangentSpaceDualNumbers` → `TangentSpaceSchemePoints` → `TangentSpaceStalkAlgebra` → `TangentSpaceIdentitySection` + `Pic0TangentSpace` | PORTABLE-AS-SHAPE (mathlib-only imports; near-verbatim port) |
| `Pic0DualNumberCocycle` §§1–3 (represented-functor T₀ = fiber/kernel machinery, **takes the `RepresentableBy` datum as an argument** — exactly the `d.rep` idiom) | PORTABLE-AS-SHAPE |
| `Pic0DualNumberCocycle` §6 Čech unit-cocycle engine (`truncExpCechKernelAddEquiv : B ⧸ (ρ₁A₁+ρ₂A₂) ≃+ Additive (cechUnitsReduction ρ₁ ρ₂).ker`, :962; Mumford scaling as `b ↦ t·b` :1037) + §7 `DualNumber.baseChangeAlgEquiv` (:1133) | PORTABLE-AS-SHAPE, top harvest — pure algebra, drops onto the Rebuild `TwoCover` section rings |
| `Pic0DualNumberCocycle` §§4–5 Mumford `ε ↦ aε` scaling | PORTABLE-AS-SHAPE; **known documented gap: `(a+b)•x` distributivity never proved anywhere** (:566-569) |
| `Pic0AbelianVariety` statement shapes (kernel-of-restriction T₀; per-conjunct properness helpers incl. proved `universallyClosed_of_baseChange` = fpqc descent of UC from `k̄`, :546; dimension-identity-first reduction :693) | PORTABLE-AS-SHAPE (shapes), PORTABLE-WITH-REWORK (proofs — FGA-gate/`relPresheaf` consumers) |
| `Pic0AbelianVariety` `smooth`/`proper` docstring routes | DO-NOT-PORT (zero formal backing; keep only reduction shapes) |
| `IdentityComponent` §1 substrate (open-closed `G⁰`, Yoneda-subgroup `GrpObj` inheritance via `ofRepresentableBy`, `baseChangeIso`, `isFiniteTypeGeometricallyIrreducible`; dep `GeometricallyConnectedSection.lean`) | PORTABLE-AS-SHAPE — **contingency only** (needed iff GI-(b)/`lem:agps`(3) route is chosen, §3.3) |
| `IdentityComponent` §3–4 (Hilbert-poly degree, `kPoints_iff_kerDegree`) and `SubProjects/Picard-IdentityComponent/` | DO-NOT-PORT (dead end; stale snapshot) |

Hygiene rules inherited: never register a sorried fact as an instance (the `sorryAx`-poisoning
incident, old `IdentityComponent.lean:481-486`); reduce to a scalar finrank identity before
producing any non-canonical `≃+` (the W12 lesson, old `Pic0TangentSpace.lean:87`); kernel-verify
every port (`2918d0235`).

---

## 3. Gap list in dependency order, per target

Legend: **[S]/[M]/[L]** size guess (≤150 lines / one ≤500-line file / multi-file campaign);
**[RISK]** = §5 entry. Paper-route citations carry the math-route reader's READ/UNREAD flags.
Milne anchor debt (mirrors R6's Mumford note, but UNPAID): the workspace Milne source (slug
`abelian-varieties`) has only pp. 14-15 (= doc pp. 8-9, Ch. I §1 rigidity) transcribed per the
manifest — the Milne III Prop 2.1 / Thm 5.1(a) / Thm 1.6 citations below relay untranscribed
content, so their READ flags are the math-route reader's, unverifiable in-workspace, and any
blueprint node citing them queues a page-transcriber task first.
Shared gaps first — both hard targets sit on them.

### 3.0 Shared substrate gaps

- **G-W5-0 [gate, not a gap]** — `JacobianData` declaration + Wave-4 producer. Wave 5 cannot touch
  the frozen gate until `jacobianData` lands; it CAN land every theorem against
  `(d : JacobianData C)` as soon as the *structure* exists (a Stage-A Wave-4 brick; the worksheet
  says it is stateable verbatim on the landed `pic0Functor` today).
- **G-W5-1 [S]** — separatedness: `IsSeparated d.J.hom` from `[GrpObj d.J]` +
  `d.locallyOfFiniteType`. Route (Kleiman `lem:agps`(1), tex 2851, READ): diagonal =
  `α⁻¹(e)` for `α = lift (fst * snd⁻¹)`; mathlib supplies `IsClosedImmersion η[G].left`
  (`Group/Abelian.lean:35`) and the Hom-group calculus; no mathlib lemma exists (§2.7 absence 8).
  Consumed by ALL properness routes and by nothing else. First-brick candidate.
- **G-W5-2 [S]** — translation transport: `GrpObj.mulRight` (`Grp.lean:275`) instantiated on
  `Over (Spec (.of k))` as scheme isos of `d.J.left`, action on (closed) points, transport of
  local properties (smooth locus, reducedness locus, irreducible opens) along it. Consumed by the
  smoothness spreading (`cor:sm`, READ), by geometric reducedness (α1), and by `lem:agps`(2)/(3)
  if taken. Mathlib does the same dance inside `Group/Smooth.lean` (private lemmas) — check
  reusability before rebuilding.
- **G-W5-3 [M]** — H¹ base-field invariance `H¹(C,𝒪) ⊗_k K ≃ H¹(C_K,𝒪)` (hence
  `genus`-invariance) — the parked deg-d5b item (§1.5). Flat/free CBC on the two-cover complex;
  the landed `relTwistPairDiffBaseChange` pattern + `Over.sectionsBaseChange` are the mechanism;
  NOT II.5. Consumed by every `k̄`-leg of smoothness and by the `dim T₀(J_k̄) = genus C` count.

### 3.1 Target 1 — `SmoothOfRelativeDimension (genus C) (Jacobian C).hom`

Dependency chain: (T-gaps: tangent space) → (S-gaps: smoothness) → (A-gap: rel-dim assembly).

**T-gaps — `T₀J ≅ H¹(C,𝒪)` through `d.rep` at `k[ε]`.** Sources: Kleiman `thm:tgtsp` (tex
3265-3408, READ with full proof); Milne III Prop 2.1 (READ; incl. the pointless-case remark "the
vector spaces and the map commute with base change"). None of this exists in the Rebuild
(greenfield certificate §2.6).

- **G-W5-T1 [M]** — dual-number test objects + represented-functor tangent kernel: port the
  old-draft 5-file chain + `Pic0DualNumberCocycle` §§1–3 (§2.8). Output:
  `pointedDualNumberPoints d.J e ≃ ker((pic0Functor C).obj(k[ε]) → (pic0Functor C).obj(k))`
  phrased through `d.rep` (the old code literally takes the `RepresentableBy` datum as an
  argument). Note `pic0`-membership over `k[ε]`: every field point of `overSpec k k[ε]` kills `ε`
  (any `k`-algebra map `k[ε] → K`, `K` a field, does), so degree-0-ness reduces to the restriction
  along `ε ↦ 0` — near-definitional from `mem_pic0Subgroup_iff` + `degAt_picEtMap`, but write the
  lemma.
- **G-W5-T2 [M]** — the truncated-exponential Čech kernel on the Rebuild carrier:
  `H¹(C,𝒪) ≃+ ker(Ȟ¹ˣ(B[ε]) → Ȟ¹ˣ(B))` for the pinned two-cover section rings. Port the §6
  engine (pure algebra, zero scheme deps) + rebuild the old `h1CokAddEquivTruncExpCechKernel`
  assembly against `TwoCover`/`Sheaf.HModule` (carrier translation — the Rebuild's H¹ *is*
  Čech-cocycle-definitional, so this should be closer to definitional than the old draft's).
- **G-W5-T3 [M]** — geometric cocycle substrate at the thickening: an invertible class on
  `C ×ₖ Spec k[ε]` trivial along `ε ↦ 0` is trivial on the two base-changed charts (nilpotent
  unit-lifting: `u` unit mod nilpotent ⇒ unit) + chart-section identification
  `Γ(V × Spec k[ε]) ≅ Γ(V)[ε]` (= landed `Over.sectionsBaseChange` at `A = k[ε]` composed with
  the portable `DualNumber.baseChangeAlgEquiv`). This is the piece the old draft's remaining
  tangent sorry (:672) reduced to — never formalized anywhere; the Rebuild's `relPic`
  (quotient-of-`CechPic`) carrier makes it more direct. Output: `ker(relPic(k[ε]) → relPic(k)) ≃+
  H¹(C,𝒪)`.
- **G-W5-T4 [M/L] [RISK R1]** — the étale-plus collapse at the thickened test: the kernel
  computed by `d.rep` lives in `picEt`/`PicEtAff`-land; T3's lives in `relPic`-land. The landed
  dictionary crosses only at field tests with a section (§2.3). Candidate closes: (i) Kleiman's
  step (v) avatar — over `k̄`, étale covers of the Artin local ring `k̄[ε]` (henselian, separably
  closed residue field) split, so `PicEtAff C_{k̄} (k̄[ε]) = relPic` on the nose; then compare over
  `k → k̄` (needs G-W5-3 + a `pic0`-kernel base-change square — Milne's pointless-case pattern);
  (ii) a direct kernel-level argument over `k` (étale covers of `k[ε]` are `K'[ε]` for `K'/k`
  finite separable, by henselian lifting; show the kernel of `ε ↦ 0` restricted to descent classes
  is already Zariski — a Hilbert-90-flavoured cancellation). **Neither the Artin-local splitting
  brick nor the henselian étale-invariance is verified to exist in the pinned mathlib**
  (`HenselianLocalRing` exists; the specific cover-splitting statement unverified). This is the
  smoothness lane's hard core.
- **G-W5-T5 [S/M]** — `k`-linearity / dimension bookkeeping: transport `finrank` through the
  T1∘T2∘T3∘T4 composite. Discipline (old-draft W12 lesson): reduce to ONE scalar identity
  `finrank κ(e) (m_e/m_e²) = genus C` first, then a single non-canonical `≃+`
  (`nonempty_cotangentSpaceAddEquiv_of_finrank_eq` shape, portable). The Mumford `ε ↦ aε` scaling
  gives `k`-structure without needing the unproved `(a+b)•x` distributivity IF the count is done
  cocycle-side (where linearity is honest module structure); flag the distributivity gap anyway
  (§5 R5).

**S-gaps — from tangent data to `Smooth d.J.hom`.**

- **G-W5-S1 [M/L] [RISK R2]** — `GeometricallyReduced d.J.hom`. Route pin (route-decision item
  13): geometric reducedness at 0 + `smooth_of_grpObj`. Sub-routes: **(α1)** square-zero lifting
  at 0 over `k̄` — all Artin-local square-zero lifts of `k̄`-points of the *functor* exist because
  the obstruction is an H² of a two-term complex, identically zero (curve-lite replacement of
  Kleiman `prp:H2`, tex 3621-3658 READ — its EGA III 7.7.5/7.7.10 Exchange steps must NOT be
  ported, §1.4); formal smoothness of `𝒪_{J_k̄,0}` ⇒ regular ⇒ reduced at 0; spread by G-W5-2
  translations; `IsReduced J_k̄` ⇒ geometrically reduced. The "functor-lifts ⇒ local ring
  formally smooth ⇒ regular/reduced" bridge is ring-level work with only partial mathlib support
  (`Algebra.FormallySmooth` lifting theorems exist; "formally smooth local k̄-algebra ⇒ reduced"
  unverified). **(α2)** dimension count: `dim₀ J ≤ dim T₀J = g` always (`cor:sm`, READ, "by
  general principles"); a lower bound `dim J ≥ g` would force regularity at 0 — but the datum
  worksheet exports no chart-dimension data, and mathlib has no dimension theory (§2.7 absence 5);
  (α2) is currently not stateable cheaply. (α1) is the live candidate.
- **G-W5-S2 [XS]** — `Smooth d.J.hom := smooth_of_grpObj` (`Group/Smooth.lean:64`): hypotheses
  `[LocallyOfFiniteType]` = `d.locallyOfFiniteType`, `[GrpObj (Over.mk d.J.hom)]` = `d.grpObj`
  (η-defeq of `Over.mk d.J.hom` with `d.J` to check), `[GeometricallyReduced]` = S1.

**A-gap — the frozen numeral.**

- **G-W5-A1 [M/L] [RISK R3]** — `Smooth` + (fiber dimension `g` at 0) ⇒
  `SmoothOfRelativeDimension (genus C)`. Nothing exists: mathlib has no
  `Smooth`→rel-dim bridge, no locally-constant-relative-dimension lemma, no rel-dim descent
  (checked this session). Candidate mechanics: standard-smooth charts exist by
  `Smooth.iff_forall_exists_isStandardSmooth`; their relative dimension at a point is pinned by
  the cotangent/`T₀` count at that point; translation homogeneity (G-W5-2, over `k̄`) makes the
  dimension uniform; then either (i) descend `SmoothOfRelativeDimension g` from `k̄` to `k`
  (needs a NEW descent lemma — probe whether `HasRingHomProperty.descendsAlong_flat` applies to
  `Locally (IsStandardSmoothOfRelativeDimension n)`), or (ii) work over `k` directly with
  `geometrically`-style transport of the fiber count. Both are unexplored. Kleiman `cor:sm`
  (tex 3421, READ) is the paper shape; Milne Prop 2.1's second clause (READ) the dimension
  statement.

### 3.2 Target 2 — `IsProper (Jacobian C).hom`

Fixed decomposition (mathlib class, `Proper.lean:42`): `IsSeparated` (= G-W5-1) +
`LocallyOfFiniteType` (= `d.locallyOfFiniteType`) + `UniversallyClosed` (the mountain; qc then
free, though `d.quasiCompact` feeds the valuative variants). Three candidate routes for UC, none
decided:

- **P-A — valuative criterion + divisor closure** (Kleiman `ex:sm=>pr` tex 3067 + `ans:sm=>pr`
  tex 5348-5379, both READ; refinements `rmk:RamSam` READ). Debts, all re-verified absent: DVR-refined
  valuative criterion [mathlib-absent, §2.7 #2]; regular-local⇒UFD in dim ≤ 2 [mathlib-absent,
  §2.7 #1; Stacks `lemma-weil-divisor-is-cartier-UFD` READ, its `more-algebra-lemma-regular-local-UFD`
  input UNREAD — More-on-Algebra not in the workspace excerpts]; fppf descent of properness for
  the reduce-to-section step [mathlib-absent, §2.7 #3] — though the old-draft
  `universallyClosed_of_baseChange` (:546, PROVED) shows UC-descent-from-`k̄` alone is a landed
  mathlib `DescendsAlong` application, which softens this leg. Head start: the (C2) effectivity
  close gives "K-point of J = line bundle on C_K" at sectioned fields. Three mathlib-absent
  bricks with no other route consumer.
- **P-B — image of the symmetric power** (Milne's own completeness step, proof of Thm 1.6 final
  paragraph, READ: "`C^{(r)} → J` … shows that `J` is complete"). Mechanism in-tree:
  `Div^d`/`C^{(d)}` proper over `k` + Abel morphism `abel : Div^d ⟶ d.J` (a `rep.homEquiv.symm`
  corollary of the universal degree-`d` class, `fiberTwist`-shifted); surjectivity at every field
  point = `riemann_inequality_curve` (`h⁰ ≥ deg + 1 − g ≥ 1` for `deg ≥ g`); field-point
  surjectivity ⇒ `Surjective abel` (residue-field points); finish by
  `UniversallyClosed.of_comp_surjective` (`UniversallyClosed.lean:77`) with the composite =
  `Div^d`'s proper structure morphism. Runs over `k` directly, no descent. Sole debt: **`Div^d` as
  a proper `k`-scheme + the Abel morphism** — Wave-6 item 16 infrastructure, explicitly shared
  with Wave 4 (route-decision item 12; DAT-D carves `Div^g`-lite *charts*, not the proper scheme —
  the delta is real, §5 R4).
- **P-C — valuative hybrid**: run mathlib's full valuative criterion
  (`UniversallyClosed.of_valuativeCriterion`, needs `d.quasiCompact`) on `d.J` but discharge the
  existence half by lifting through `Div^d`: twist by `fiberTwist`, choose an effective
  representative over the fraction field (`h⁰ ≥ 1`), extend by properness of `Div^d` (where
  mathlib's criterion applies with no DVR refinement), push forward. Same `Div^d` debt as P-B;
  avoids both P-A algebra mountains and P-B's image-topology step (replaces it with valuative
  bookkeeping).

Fit observation (NOT a decision): P-B and P-C consume only landed clauses + the shared `Div^d`
debt; P-A consumes three mathlib-absent bricks. The w4-datum-worksheet consumption row's
"…+ valuative" prose leans P-A/P-C; no Wave-5 route document binds this yet.

### 3.3 Target 3 — `GeometricallyIrreducible (Jacobian C).hom`

First, a scope collapse to record: `geometrically` quantifies over ALL morphisms
`y : Spec K ⟶ Spec (.of k)` (`Geometrically/Basic.lean:46`), but every such `y` is `Spec` of a
ring map `k → K`, i.e. a `k`-algebra point — so the obligation is uniform-in-`K/k` irreducibility
of `J_K`, matching the `pic0Subgroup` quantifier shape exactly.

- **GI-(a) — `C^{(d)} ↠ J` at every field point** (wave3 §6.3 route (a); Milne Thm 5.1(a) READ;
  Kleiman `ex:jac` context READ). For every field `K/k`: `C_K^d` is integral (iterated
  `isIntegral_tensorObj_left` `Rigidity.lean:160` + the landed `BaseChangeInstances` stack),
  `C^{(d)}_K` its continuous surjective image hence irreducible, and `C^{(d)}_K → J_K` surjective
  by the same `h⁰ ≥ 1` count as P-B (uniform in `K`); image of irreducible is irreducible ⇒
  `IrreducibleSpace J_K`. Delivers `GeometricallyIrreducible` **directly, no identity-component
  theory, no connectedness detour** — and shares its entire substrate with P-B/P-C. Debts: `Sym^d`
  existence (same shared debt), a small "irreducible image" topology brick, and enough
  functoriality to read the surjection over every `K` (the base-change instances are landed;
  the Abel-morphism-over-`K` compatibility is `rep`-naturality).
- **GI-(b) — degree strata + χ local constancy in flat families** (wave3 §6.3 route (b); Kleiman
  `prp:algeq` tex 3232 READ; `thm:Pphifin` proof inputs `lem:bd`/`lem:hp` UNREAD). **This is the
  named Mumford-II.5 re-entry consumer** (§1.4): "χ of a family locally constant off the vanishing
  locus" = II.5.1's descending induction on top of COH. Choosing (b) fires the recorded re-entry;
  choosing (a) keeps the descope intact. Note the re-entry's citation debt is already paid — the
  II.5 pages are transcribed and citable (§1.4, §5 R6) — so (b)'s marginal cost is the Lean
  add-on brick itself, to be queued, not assumed.
- **GI-packaging (contingency)** — if the design pass wants `lem:agps`(3) anyway (tex 2851-2911,
  READ with full proof: `G⁰` open-closed, finite-type, geometrically irreducible, commutes with
  field extension), the old-draft `IdentityComponent.lean` §1 substrate is the sorry-free port
  (§2.8) — but it presupposes connectedness of `J` (wave3 §6.3), so it cannot replace (a)/(b) as
  the source. If smoothness (target 1) lands first, "connected + smooth ⇒ irreducible" is a cheaper
  finish (mathlib availability of connected+normal⇒irreducible: unverified — open question).

Dependency-order summary across targets: G-W5-1 and G-W5-2 and G-W5-T1/T2 are launchable now
(against the datum-as-section-variable); G-W5-T3 → T4 → T5 → S1 → S2 → A1 is the smoothness
chain; UC and GI share the `Div^d`+Abel debt and can be sequenced as one substrate; targets 2 and
3 are independent of the smoothness chain except that GI's cheap finish variant and Wave-6's
`GeometricallyIntegral` bookkeeping both consume target 1.

---

## 4. Candidate brick decomposition — **CANDIDATE ONLY; cuts and sequencing reserved to the design pass**

House format: name — inputs ⇒ outputs; size class [XS/S/M/L]; notes. All statements against
`(d : JacobianData C)` per the binding consumption header; none touches the frozen file.

**Cluster X (shared substrate; launchable first):**
- **W5-X1 `separated`** — `d.grpObj`, `d.locallyOfFiniteType`, mathlib `IsClosedImmersion η[G].left`
  ⇒ `IsSeparated d.J.hom`. [S]. `lem:agps`(1) diagonal-as-`α⁻¹(e)`; candidate mathlib-general
  statement (any `GrpObj` over a field with separated-diagonal bookkeeping) — check upstream appetite.
- **W5-X2 `translation`** — `d.grpObj` ⇒ translation isos of `d.J` + transport lemmas for
  point-local properties. [S]. Mine `Group/Smooth.lean`'s private homogeneity lemmas first.
- **W5-X3 `h1-base-change`** — landed two-cover CBC pattern ⇒ `H¹(C,𝒪) ⊗_k K ≃ₗ[K] H¹(C_K,𝒪)`,
  corollary `genus`-invariance. [M]. The parked deg-d5b D2 item; engine-grade, not II.5.

**Cluster T (tangent space; the smoothness feeder):**
- **W5-T1 `dual-number-kit`** — old-draft 5-file chain + `Pic0TangentSpace` ⇒ Rebuild-namespace
  tangent substrate (pointed dual-number points, cotangent dual, `≃+`-from-finrank reduction).
  [M, port]. Kernel-verify; keep the `Subsingleton (PrimeSpectrum k)` point-presentation idiom uniform.
- **W5-T2 `trunc-exp-cech`** — old-draft §6 engine + §7 `baseChangeAlgEquiv` ⇒
  `H¹(C,𝒪) ≃+ ker(Ȟ¹ˣ(B[ε]) → Ȟ¹ˣ(B))` on the pinned `TwoCover` section rings. [M, port+translate].
- **W5-T3 `relpic-epsilon-kernel`** — T2 + `Over.sectionsBaseChange` at `k[ε]` + nilpotent
  unit-lifting ⇒ `ker(relPic C (overSpec k k[ε]) → relPic C (overSpec k k)) ≃+ H¹(C,𝒪)`. [M].
  The old draft's un-closed reduced core; better placed here (Čech-definitional `Pic`).
- **W5-T4 `etale-plus-epsilon`** — T3 + Artin-local étale splitting (or kernel-level Hilbert-90)
  ⇒ `ker(pic0(k̄[ε]) → pic0(k̄)) ≃+ H¹(C_k̄,𝒪)`, then the `k → k̄` comparison square via W5-X3.
  [M/L, **WORKSHEET-FIRST**]. Risk R1; the design pass should scope the splitting brick before
  committing.
- **W5-T5 `t0-dimension`** — T1..T4 + `d.rep` ⇒ the scalar identity
  `finrank (m_e/m_e²)-dual = genus C` at the identity of `d.J` (over `k̄`, and over `k` if T4(ii)
  lands). [S/M]. Scalar-identity-first discipline.

**Cluster S (smoothness):**
- **W5-S1 `geom-reduced-at-zero`** — T-cluster + two-term-H²=0 + ring-level `FormallySmooth`
  lifting ⇒ `GeometricallyReduced d.J.hom`. [M/L, **WORKSHEET-FIRST**]. Risk R2; sub-route α1;
  must NOT import Kleiman `prp:H2`'s Exchange steps (descope boundary).
- **W5-S2 `smooth`** — S1 + certificates ⇒ `Smooth d.J.hom` via `smooth_of_grpObj`. [XS].
- **W5-S3 `rel-dim-assembly`** — S2 + T5 + W5-X2 (+ a NEW rel-dim uniformity/descent lemma) ⇒
  `SmoothOfRelativeDimension (genus C) d.J.hom`. [M/L, **WORKSHEET-FIRST**]. Risk R3; probe the
  `HasRingHomProperty` descent question early — it decides whether the whole chain can live at `k̄`.

**Cluster P (properness):**
- **W5-P1 `divd-abel`** — (cross-wave) `Div^d`/`C^{(d)}` as a proper `k`-scheme + Abel morphism
  `Div^d ⟶ d.J` via `rep.homEquiv.symm` + `fiberTwist`. [L, shared with Wave 4 DAT-D / Wave 6
  item 16 — coordinate ownership before speccing]. Feeds P2 AND G1.
- **W5-P2 `universally-closed`** — P1 + `riemann_inequality_curve` +
  `UniversallyClosed.of_comp_surjective` (route P-B) or + `of_valuativeCriterion` on `Div^d`
  (route P-C) ⇒ `UniversallyClosed d.J.hom`. [M once P1 exists]. Route choice = design pass;
  P-A only if the design pass explicitly budgets the two algebra mountains.
- **W5-P3 `proper-assembly`** — X1 + P2 + `d.locallyOfFiniteType` ⇒ `IsProper d.J.hom`. [XS].

**Cluster G (geometric irreducibility):**
- **W5-G1 `geom-irred`** — P1 (over every `K`, via the landed base-change instances +
  `isIntegral_tensorObj_left`) + an irreducible-image topology lemma ⇒
  `GeometricallyIrreducible d.J.hom` (route GI-(a)). [M once P1 exists].
- **W5-G2 `identity-component-port`** — old-draft §1 substrate. [L, **CONTINGENCY ONLY** — spec
  only if the design pass rejects GI-(a)].

Sequencing suggestion (non-binding): X1/X2/T1/T2 immediately (no gates beyond the `JacobianData`
declaration for X1/X2 statements; T1/T2 gate on nothing); X3 + T3 next; T4 and S3 get worksheets
before code; P1 is the single biggest cross-wave coordination item — surface it to the
orchestrator now, since P2/P3/G1 (two of three targets!) queue behind it.

---

## 5. Honest risks — what reading could not settle

The cautionary precedents are in-house: (C2)'s "one delicate step" became an fppf-effectivity
campaign; the old draft's `smooth`/`proper` are docstring sketches with zero formal backing.
Ranked:

- **R1 — the étale-plus/Zariski kernel crossing at `k[ε]` (W5-T4) is the smoothness lane's
  balloon candidate.** The landed dictionary (`unitEquiv_of_section`) covers only sectioned field
  tests; at `k[ε]` (or `k̄[ε]`) nothing exists. The Artin-local splitting brick ("étale covers of a
  henselian local ring with separably closed residue field split") is unverified in the pinned
  mathlib, and the alternative kernel-level cancellation over `k` is undesigned. This has the
  exact (C2) shape: a comparison the paper treats as invisible (`ex:Alr`, "étale sheafification is
  invisible at an algebraically closed point") whose Lean content is a genuine descent statement.
  Worksheet-first; budget a campaign-scale fallback.
- **R2 — "geometrically reduced at 0" (W5-S1) has no formal substrate anywhere.** The old draft's
  `smooth` sorry (:806) is exactly this hole. The curve-lite replacement of `prp:H2` (H² of
  two-term complexes = 0) is sound as prose, but the bridge "functor-level square-zero lifting ⇒
  `𝒪_{J,0}` formally smooth ⇒ regular ⇒ reduced" crosses from functor-of-points to local algebra
  through `d.rep`, and mathlib's `FormallySmooth` is ring-level only. Unsettled by reading: whether
  a *reducedness-only* shortcut (lift units/nilpotents directly) avoids the full formal-smoothness
  detour. If a prover reaches for semicontinuity/Exchange here, that is a route deviation (descope
  boundary).
- **R3 — the frozen numeral: no path from `Smooth` to `SmoothOfRelativeDimension (genus C)` exists
  in any tree.** Mathlib absence re-verified this session (no bridge, no fiber-dim theory, no
  rel-dim descent instance). Open probes: does `HasRingHomProperty.descendsAlong_flat` instantiate
  at `Locally (IsStandardSmoothOfRelativeDimension n)`? Is rel-dim Zariski-locally constant on an
  irreducible base provable cheaply from the standard-smooth presentation? Either answer reshapes
  W5-S3 from [M] to [L]. This gap is invisible in the paper sources (papers say "smooth of
  dimension g" as one breath) — it is a Lean-only mountain and the reason item 13's [S] tag is
  suspect.
- **R4 — the `Div^d` cross-wave debt is load-bearing for TWO of the three targets and is owned by
  nobody yet.** DAT-D (Wave 4) carves `Div^g`-lite *charts*; Wave-6 item 16 builds `Sym^r` as a
  scheme; P-B/P-C/GI-(a) need `Div^d` as a *proper scheme with an Abel morphism*. The deltas
  (charts vs scheme; scheme vs proper scheme + morphism) are real and unbudgeted. If `Div^d`
  slips, the only properness route left is P-A with its two mathlib-absent algebra mountains
  (regular-local⇒UFD; DVR-refined valuative criterion) — i.e. Wave 5's properness could inherit a
  commutative-algebra campaign. Surface to the orchestrator during the design pass.
- **R5 — (C2)-style choice-vs-equality traps, Wave-5 edition.** (i) Everything must consume the
  pinned `d.rep` datum — any `Nonempty`/`Classical.choose` extraction of a representing object
  reproduces the old draft's banned FGA gate (`FGAPicRepresentability.lean:265-317`). (ii) The
  tangent identification must be an equiv-chain with dimension transported through ONE scalar
  identity (W12 lesson) — never finrank along a bare `Equiv`. (iii) The Mumford-scaling
  distributivity `(a+b)•x` was never proved anywhere (old
  `Pic0DualNumberCocycle.lean:566-569`); the Rebuild's `picEt` being an honest étale-plus object
  *may* close it against `k[ε] ×ₖ k[ε] = k[ε₁,ε₂]`, or the count can dodge it cocycle-side —
  unsettled by reading; do not let a prover discover this mid-brick. (iv) Never register a
  sorried/staged fact as an instance (sorryAx-poisoning incident).
- **R6 — the Mumford II.5 descope boundary, what the engine does NOT provide.** Naive AV-package
  routes assume: semicontinuity of `h^i`, the Exchange property (EGA III 7.7.5-II/7.7.10 inside
  Kleiman `prp:H2`), cohomology-and-base-change off the vanishing locus, χ locally constant in
  flat families, and the rank export/sheaf-level fibre discharge (frozen as DAT-3, Wave-4 cbc
  lane). The landed engine provides exactly: coherence, fibrewise-vanishing openness, and (on the
  vanishing locus) `H¹ = 0` + `H⁰` finite projective with on-the-nose module/ring base change.
  Consequences already folded in: smoothness must use the two-term-H²=0 replacement (never
  Exchange); GI-(b) fires the recorded II.5.1 re-entry (an add-on brick ON TOP of COH — possible,
  but it must be *queued*, not assumed); anchor debt PAID — Mumford II.5 (book pp. 46-55) is
  fully transcribed as of 2026-07-16 (`mumford-abelian-varieties:page-0057`..`page-0066` per the
  manifest, incl. the II.5.1 Grothendieck complex, Lemmas 1-2, and Corollaries 1-6/seesaw;
  spot-checked same day), so Wave-5 blueprint nodes may cite II.5 directly with no
  page-transcriber task; the II.5.1 re-entry's remaining cost is the Lean add-on brick alone.
- **Lower-order unknowns** (reading could not settle; park as design-pass probes): whether
  `Over.mk d.J.hom` is η-defeq enough to `d.J` for `smooth_of_grpObj`/`IsClosedImmersion η` to
  apply without transport lemmas; whether mathlib's `Group/Smooth.lean` private homogeneity lemmas
  are reusable or must be re-proved (W5-X2); whether "connected + smooth/normal ⇒ irreducible"
  exists in mathlib (the GI cheap-finish variant); whether `pic0`-membership-at-`k[ε]`-reduces-to-
  `ε↦0` really is one lemma (T1 note) or hides a subtlety at non-reduced test objects in the
  `degAt` quantifier; and the exact instance-vs-theorem packaging that lets the three targets be
  `instance`s at the frozen gate while all Wave-5 files phrase them as theorems about `d.J`.

---

*End of recon. §3 headline: three shared gaps (G-W5-1/2/3), a five-step tangent chain with one
balloon candidate (T4), a two-step smoothness chain with two worksheet-first mountains (S1, A1),
and a two-route UC/GI pair whose cheap branch hangs on the unowned cross-wave `Div^d` debt (R4).
§4 is CANDIDATE decomposition only; the design pass decides routes P-A/B/C, GI-(a)/(b), S-α1/α2,
and all brick cuts.*
