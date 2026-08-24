# SPEC DD-1 — the divisor-functor pin (`AJCR.w4-rep.datum.dat-d.dd1`)

*2026-07-17, Fable prover-architect (second launch; first was quota-killed with nothing
landed). BINDING parent: `informal/dat-d-worksheet.md` §1 (the D1 pin), §5 DD-1, §6
risk 4, Discipline; consumers: §4.2 rows, `informal/dd-f-probe-verdict.md` (DD-1c is
the DD-F→DD-R translation layer), DAT-B, DD-4. Templates: `informal/spec-dat-1.md`
(the §3.2 normalization this adapts), `informal/spec-dd-3.md` (the rankAtStalk gift,
evaluated below). The §6-risk-4 ELABORATION PROBE was RUN before freezing anything
(scratch `ProbeDD1.lean`, `lake env lean` green against the pinned tree + mathlib
v4.31.0); every spelling below elaborates. Kernel discipline 07-14/14b/15 binding.*

## 0. Standing pack and vocabulary (all landed)

`{k} [Field k]`, `C : Over (Spec (.of k))`, `π : C.left ⟶ P1 k` `[IsAffineHom π]`; test
algebra `R : Type u` `[CommRing R] [Algebra k R]`. Curve `relCurve C R`
(`RelativeTwoCover.lean:115`) with the pinned charts
`(relCover C R (fiberTwoCover π)).V₀/V₁`; test change `relCurveMap C R R'`
(`RelativeSectionsLinear.lean:160`) with `relSectionsMap` + `_smul/_resHom/_pullback`;
chart base change from the base field `Over.sectionsBaseChange`
(`SectionsBaseChange.lean:287`, qcqs opens, with naturality) and its R-linear form
`relSectionsBaseChange` (`RelativeSectionsLinear.lean:99`). Algebra structures: the
house local instances `Scheme.overSectionsAlgebra` (`ChartColength.lean:78`) +
`relCurve.instOver`, `Scheme.overModule`. Divisor carrier `Scheme.LocalEquations`
(`DivisorClass.lean:112`) with `picClass/restrict/mul/rescale` + class laws and
`LocalEquations.pullback` (`LocalEquationsPullback.lean:118`, regularity hypothesis
`hreg` explicit).

## 1. The frozen carrier spellings (probe-verified)

**(1a) The finite chart adaptation** — DAT-1's §3.2 cover normalization with regular
equations instead of units, in a **`Fin`-indexed** spelling:

```
structure FinCoverData (C R π) : Type u :=      -- NOT BasicOpenCoverData (Type (u+1)!)
  m₀ m₁ : ℕ
  h₀ : Fin m₀ → Γ(C_R, V₀ᴿ)   h₁ : Fin m₁ → Γ(C_R, V₁ᴿ)   a₀ a₁ : …
  partition₀ : ∑ j, a₀ j * h₀ j = 1              partition₁ : …
-- index := Fin m₀ ⊕ Fin m₁ ; pieces := Sum.elim (basicOpen ∘ h₀) (basicOpen ∘ h₁)

structure DivisorAdaptation (d : (relCurve C R).LocalEquations) extends FinCoverData :=
  eqn      : ∀ j : index, Γ(C_R, pieces j)                 -- the equations f_j
  pt       : index → relCurve C R                          -- refinement witness:
  piece_le : ∀ j, pieces j ≤ d.cover.opens (pt j)          --   each piece sits in a
  unit     : ∀ j, Γ(C_R, pieces j)ˣ                        --   member of d.cover and
  eqn_eq   : ∀ j, eqn j = unit j * res (d.eqn (pt j))      --   f_j = u_j · d-equation
```

PROBE FINDING (drives the `Fin` decision): DAT-1's `BasicOpenCoverData` carries
`J₀ J₁ : Type u` fields, hence lives in `Type (u+1)` — fatal for a functor VALUE
(`DivFam` must be `Type u`, the PicEt vehicle smallness). `Fin`-indexing keeps
everything `Type u` (probe P1); DAT-1's coverage lemma
`le_iSup_basicOpen_of_sum_eq_one` fires verbatim on the `Fin` families. A converter
`toBasicOpenCoverData` (J₀ := Fin m₀ …) is a thin def if a consumer wants DAT-1's
datum shape. Regularity and overlap unit-ratios of the `eqn j` are DERIVED from
`eqn_eq` + `d.regular`/`d.ratioUnit` (lemmas, not fields — the rescale-proof pattern
of `DivisorClass.lean:413`).

**(1b) The colength modules and the glued equalizer** (probe P2/P3; all under the
local instances of §0):

```
colength j      := Γ(C_R, pieces j) ⧸ Ideal.span {eqn j}          -- an R-algebra
ovlIdeal i j    := Ideal.span {res⁻ˡ (eqn i), res⁻ʳ (eqn j)}      -- SYMMETRIC span
ovlColength i j := Γ(C_R, pieces i ⊓ pieces j) ⧸ ovlIdeal i j
toOvlLeft/Right : colength i/j →ₐ[R] ovlColength i j              -- Ideal.Quotient.liftₐ
chartProd := Π j, colength j        ovlProd := Π p : index × index, ovlColength p.1 p.2
deltaLeft/Right : chartProd →ₗ[R] ovlProd                         -- LinearMap.pi/proj
gluedSubmodule  := LinearMap.eqLocus deltaLeft deltaRight         -- W(d), the worksheet eq(∏⇉∏)
```

Decisions recorded: (i) the overlap quotient is by the symmetric two-generator span —
no ideal-equality transport in the DEFINITION (that `span {res f_i} = span {res f_j}`
on overlaps, from the derived unit ratio, is a LEMMA used in proofs); (ii) restriction
enters as `relResAlgHom : Γ(V) →ₐ[R] Γ(W)` (`AlgHom.mk'` over
`overAlgebraMap_apply_res`) — one def, all quotient maps are `liftₐ/mkₐ` composites;
(iii) `chartProd/ovlProd` MUST be `abbrev`s — the opaque-def spelling makes the
`Pi.module` instances non-defeq to the custom ones and every `LinearMap.pi` statement
fails (probe finding, the FLV-§5.2-class hazard of worksheet risk 4, resolved);
(iv) `eqLocus` (not a hand-rolled subtype) — it is mathlib's `Flat/Equalizer.lean`
vocabulary, which gives DD-1b for free (§3).

**(1c) The certificate.** Prop-structure `DivisorAdaptation.IsCertified n`:

```
finite_colength     : ∀ j, Module.Finite R (colength j)            -- (c1)
projective_colength : ∀ j, Module.Projective R (colength j)        -- (c1)
finite_glued        : Module.Finite R Glued                        -- (c2)
projective_glued    : Module.Projective R Glued                    -- (c2)
rankAtStalk_glued   : ∀ p, Module.rankAtStalk Glued p = n          -- (c2), see below
flat_coker_incl     : Module.Flat R (chartProd ⧸ gluedSubmodule)               -- (c3) NEW
flat_coker_diff     : Module.Flat R (ovlProd ⧸ range (deltaLeft - deltaRight)) -- (c4) NEW
```

- **rankAtStalk evaluation (the DD-3 note's question): ADOPTED.** `Module.rankAtStalk`
  is honest finrank (defined via localized finrank; `Module.rankAtStalk_eq` bridges to
  `finrank κ(p) (Fiber p M)` — never `Nonempty`), it has the exact base-change lemma
  `rankAtStalk_baseChange` (`FreeLocus.lean:326`), and it is the SAME field mathlib's
  `Module.Grassmannian` carries — so DD-4's embedding has no rank-spelling seam.
- **(c3)/(c4) are a sanctioned spelling deviation** (worksheet §6.8 gives the exact
  certificate fields to this spec). The probe's main mathematical finding: the pinned
  (c1)+(c2) alone do NOT base-change. For `W = ker δ` (`δ := deltaLeft − deltaRight`),
  `W ⊗ R' → ker (δ ⊗ R')` has cokernel `ker((im δ → ovlProd) ⊗ R')`, controlled by
  NO clause of (c1)/(c2) over a non-reduced test ring; the worksheet's "split-kernel
  RE-3 pattern" needs the two cokernel flatnesses as input. (c3)+(c4) are exactly the
  Čech-flatness residue: **trivial over any field** (every module over a field is
  flat), **transported by right-exactness** (coker(δ)⊗R' = coker(δ⊗R'), then
  `Module.Flat.baseChange`), and together they CLOSE certified base change by two
  applications of mathlib's purity gift (§3). This mirrors the worksheet's own move of
  relocating the balloon into named hypotheses rather than hiding it. DD-R obligation
  recorded: the Z(♦) construction must discharge (c3)/(c4) from its ambient
  normalization — flagged as the DD-R seam.

**(1d) The certified family, setoid, and functor value** (probe P7):

```
structure CertifiedDivisorFamily (n : ℕ) : Type u :=
  eqns : (relCurve C R).LocalEquations
  adaptation : DivisorAdaptation C R π eqns
  certified : adaptation.IsCertified n

DivEq d₁ d₂ : Prop := ∃ (𝒲 : PointedCover) (h₁ : 𝒲 ≤ d₁.cover) (h₂ : 𝒲 ≤ d₂.cover),
  ∀ x, ∃ u : Γ(𝒲.opens x)ˣ, res (d₁.eqn x) = u * res (d₂.eqn x)

DivFam n R := Quotient (setoid: F ≈ G ↔ DivEq F.eqns G.eqns)        -- Type u
```

The relation is the ∃-pointwise-unit form (refinement + rescaling in one move): its
equivalence proof needs only unit inverse/product algebra and restriction
composition; the chosen-rescaling form `restrict = rescale ∘ restrict` is equivalent
but needs a `rescale`-calculus (rejected — more lemmas, same content). `picClass`
descends to `DivFam` by `picClass_restrict` + `picClass_rescale` (the adaptation and
certificate do NOT enter the relation; they are per-representative data).

**(1e) The vehicle at general tests** — verbatim `PicEt.lean:9–36` / DD-3 spec §2:
`divFam n T := {s : Π U : T.left.affineOpens, DivFam n Γ(T.left, U.1) //
compatibility under mapAlg (Over.resAlgHom T h)}`, `Type u`; affine comparison
`divFamAffineEquiv : divFam n (overSpec k R) ≃ DivFam n R` (top-open collapse).
Functoriality in T along arbitrary test MORPHISMS is NOT DD-1's (it needs the sheaf
gluing — DD-2's lane, as for PicEtMap).

## 2. The Tor-lemma home — FIXED (shared with DAT-A2; first-commit rule)

No DAT-A spec/commits exist in the ledger at freeze time, so per the coordination rule
this spec fixes the home: **`AlgebraicJacobian/Picard/FlatCokernel.lean`** (pure module
algebra, no schemes, parallel-safe; the `Picard/` layer per worksheet §5 DD-1).
Contents ("`lm:ctn`-lite"):

- MATHLIB GIFT (probe P6, verified): `LinearMap.lTensor_injective_of_exact_of_flat`
  (`Mathlib/RingTheory/Flat/Equalizer.lean`): SES `0 → M → N → P → 0` with `P` flat ⟹
  `A ⊗ M → A ⊗ N` injective for every `A`. THE purity core; do not re-prove.
- (L3) `tensorKer_bijective_of_flat_coker`: for `δ : M →ₗ[R] N` with
  `[Flat R (M ⧸ ker δ)]` `[Flat R (N ⧸ range δ)]`, the canonical
  `LinearMap.tensorKer R' R' δ` (mathlib's comparison map — SAME map as the flat-R'
  case, two sufficient conditions, one seam) is bijective; equiv packaging mirroring
  `LinearMap.tensorKerEquiv`, and the `eqLocus` corollary (`eqLocus = ker (sub)` via
  `LinearMap.eqLocus_eq_ker_sub`). Proof route (probed at statement level): factor
  `δ = δ̄ ∘ mkQ`, purity on `0 → ker δ → M → M⧸ker δ → 0` [(c3)] and on
  `0 → M⧸ker δ → N → N⧸range δ → 0` [(c4)], right-exactness (`lTensor_exact`) for the
  range identification, `codRestrictOfInjective` packaging à la `tensorKerInv`.
- (L2) `nonZeroDivisor_includeRight_of_flat_coker`: `f ∈ B⁰` with
  `[Flat R (B ⧸ span {f})]` ⟹ `includeRight f ∈ (R' ⊗[R] B)⁰` for every `R'` —
  purity on `0 → B →(mulLeft f) B → B/(f) → 0`. This is DD-1a's `hreg` discharge and
  the shape DAT-A2's germ-regularity bridge shares (their fibrewise⟹relative
  direction is ALSO welcome in this file — one home, no duplication).

## 3. Stage plan (commit each green; files `Picard/DivisorFamily*.lean`, ≤ 500 each)

| stage | file | contents (keystones bold) |
|---|---|---|
| (a) | `Picard/FlatCokernel.lean` | §2: **`tensorKer_bijective_of_flat_coker`** (+equiv, eqLocus form), **`nonZeroDivisor…of_flat_coker`** |
| (b) | `Picard/DivisorFamily.lean` | §1a–1d: `FinCoverData` (+pieces/coverage), `relResAlgHom`, `DivisorAdaptation` (+derived regularity/ratio lemmas), colength/ovl/delta/**`gluedSubmodule`**, **`IsCertified`**, `CertifiedDivisorFamily`, **`DivEq` setoid + `DivFam`**, **`picClass` descent** |
| (c) | `Picard/DivisorFamilyPullback.lean` | DD-1a: adaptation pullback along `relCurveMap` (h/a/f through `relSectionsMap`; partition by `map_sum`; pieces by `preimage_basicOpen`), `LocalEquations.pullback` with **`hreg` from (L2)** through the stalk-localization seam, the colength base-change squares (chart level: `relSectionsBaseChange` + localization-commutes-with-tensor at the pieces; overlap: same + quotient right-exactness), **certificate transport** ((c1) f.p.: `FinitePresentation` baseChange + `Flat.baseChange` + `projective_of_finitePresentation`; (c2): (L3) + `rankAtStalk_baseChange`; (c3)/(c4): right-exactness + `Flat.baseChange`), **`DivFam.mapAlg`** (+ id/comp laws, DivEq-invariance). DD-1b = `mapAlg` at localizations/restrictions (mathlib `tensorEqLocusEquiv` gives the flat case directly — a named corollary) |
| (d) | `Picard/DivisorFamilyExtraction.lean` | finite-adaptation extraction: every `LocalEquations` on `C_R` refines to a `DivisorAdaptation` (chart quasi-compactness + basic-open refinement + partition witnesses from span-⊤ on affine charts — the DAT-1 (1f) pattern, certificate NOT included) |
| (e) | `Picard/DivisorFamilyVehicle.lean` | §1e vehicle + **`divFamAffineEquiv`** |
| (f) | `Picard/DivisorFamilyField.lean` (+`…FieldDegree.lean` if 500-line split needed) | DD-1c: over `K` (field pack, `IsIntegral (relCurve C K)` etc.): **`divFamFieldEquiv : DivFam n K ≃ {D : CurveDivisor // 0 ≤ D ∧ deg K D = n}`** as named equiv with computation lemmas — forward: `presentationDivisor ∘ presentation` on `eqns` (effectivity from equation regularity via `ordZ ≥ 0`; **degree = n** via `finrank_quotient_span_section` per piece + the support-splitting CRT across the equalizer); backward: `pointEquations`-products (`PointPresentation.lean:255`) + a support-separating adaptation (choose pieces isolating the support points: overlap colengths vanish, `W = Π colength`, certificate by `finrank` count; (c3)/(c4) free over a field); the two inverse laws through `ordZ`-reading (`RefinementInjectivity` pattern) |

Stage (f) is the heaviest single stage (DAT-B's consumption surface and the DD-F→DD-R
translation layer); it may trail the others as its own lane — its STATEMENT is frozen
here.

## 4. Consumer map

| deliverable | consumer |
|---|---|
| `DivFam`/`divFam` + `mapAlg` + picClass descent | DD-2 (sheaf property), DD-4 (embedding ε), DAT-C (Abel data) |
| `IsCertified` fields (rankAtStalk spelling) | DD-4 (corank-g certificates — same predicate as mathlib `Module.Grassmannian.rankAtStalk_eq`) |
| certified base change (stage c keystones) | DD-1b/vehicle, DD-4 naturality, DAT-C 01JJ pullback rows |
| `FlatCokernel.lean` (L2/L3) | DAT-A2 (shared home), DD-R local generators |
| extraction (stage d) | DD-1c backward, DAT-B coverage |
| `divFamFieldEquiv` + computation lemmas | DAT-B, DD-F formalization lane (P-fib translation), DD-R fibrewise steps |
| (c3)/(c4) discharge obligation on Z(♦) | DD-R (RECORDED SEAM) |

## 5. Discipline notes

Worksheet Discipline verbatim, plus: no numeric windows appear anywhere in DD-1
(nothing to route through DD-0); `set_option autoImplicit false` + explicit binders
everywhere; `backward.isDefEq.respectTransparency false` expected ONLY where
`relCurve`/product spellings mix (stages c/f — the RelativeSectionsLinear precedent,
standard comment); the local-instance header
`attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra` is part of
every statement's meaning — consumers must activate the same instances (house rule);
keystones `lean_verify`, axioms exactly `[propext, Classical.choice, Quot.sound]`;
lake under the mkdir-mutex (`protocol-concurrent-lanes.md`), ledger commits
private-index+CAS with `show --stat HEAD` verification; root import edits minimal,
re-read first.

*End of spec. Binding for the DD-1 stages; deviations require re-derivation from the
worksheet and a note in the stage commit message.*

## ADDENDUM (2026-07-17, same session, post-landing sweep) — ledger reconciliation

- **The Tor home is now a PAIR, by commit race, with complementary content and no
  duplication**: this lane landed the base-change half first
  (`Picard/FlatCokernel.lean`, 357ac8e59 — kernels/regular elements commute with
  arbitrary base change from flat cokernels); DAT-A2 landed the fibrewise⟹relative
  half in `Picard/FibrewiseRegular.lean` (f76c0bff4 — fibrewise-regular + flat ⟹
  regular over Noetherian, Tor-free, with `mem_nonZeroDivisors_of_forall_tmul_residueField`
  as DD-R's bridge) marking the base-change half as a seam. RECONCILED READING: the
  "one home" of worksheet §5 DD-1 is the pair {FlatCokernel = base-change direction,
  FibrewiseRegular = fibrewise direction}; consumers pick by direction; neither file
  re-proves the other's lemmas. Stage (c) of this spec consumes FlatCokernel; DD-R
  consumes both.
- **Stage (c)'s geometric squares partially arrive from DAT-1 (1d-ii)** (1671218d2,
  landed): CONSUME `Scheme.Hom.appLE_resHom`, `relSectionsMap_basicOpen` (basic opens
  of compared sections are `relCurveMap`-preimages — the `pieces` transport),
  `relCurveMap_appLE_overAlgebraMap`, and mirror `BasicOpenCoverData.baseChange` for
  the `Fin`-indexed cover data. The TERM identifications
  (`B' ⊗[B] Γ(D(h_j)) ≅ Γ(D(h'_j))`, "localization commutes with base change") are the
  announced SECOND HALF of (1d-ii) in the DAT-1 lane — stage (c) must consume, not
  re-derive them; if that half stalls, negotiate ownership before building.
- **Stage (d) (extraction) deferral note**: DAT-1's (1f) finisher builds the same
  finite basic-open refinement engine (qc + span-⊤ partition witnesses); check its
  landing before writing the extraction, and share the refinement lemmas.
