Measurement complete. Report follows.

---

# Measurement report

Root path for all `file:line` below: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`

## 1. `DivFamZar.exists_certChartCover`

`AlgebraicJacobian/Picard/DivRepClassifyZarKit.lean:433`. Verbatim statement:

```lean
theorem DivFamZar.exists_certChartCover (F₀ : DivFamZar C S π g) :
    ∃ (m : ℕ) (r : Fin m → S), Ideal.span (Set.range r) = ⊤ ∧
      ∀ p : Fin m,
        ∃ (G : CertifiedDivisorFamily C (Localization.Away (r p)) π g)
          (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
          (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] Localization.Away (r p)),
          (DivFam.mk G).toZar = DivFamZar.mapAlg (Localization.Away (r p)) g F₀ ∧
          (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule
            = Submodule.map
                (LinearMap.baseChange (Localization.Away (r p))
                  b₁.equivFun.toLinearMap)
                (divFamEps hπ g (DivFam.mk G)).1 ∧
          (Module.Grassmannian.map w (pairTautSnd k g r₁ r₂ i j)).toSubmodule
            = Submodule.map
                (LinearMap.baseChange (Localization.Away (r p))
                  b₂.equivFun.toLinearMap)
                (divFamEps hπ g (DivFam.mk G)).2
```

Section binders in scope (`section Curve`, `DivRepClassifyZarKit.lean:121-150`) — these are the full instance/hypothesis context, and note `include hO hχ` at `:427` (so `hπ` enters only via the `divFamEps hπ` in the statement):

```lean
variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable {π : C.left ⟶ P1 k} [IsFinite π]
noncomputable local instance instOverCleftRepClassifyKit : C.left.Over (Spec (CommRingCat.of k))
variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g : ℕ)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
variable (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
variable (r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k …)   -- window M
variable (b₂ : Module.Basis (Fin r₂) k …)   -- window M+s
variable {S : Type u} [CommRing S] [Algebra k S]
```
(`:128` and `:131-138` truncated in the outline are the full instance list; lines 125-150 as shown.)

**What its proof consumes at top level** (`:446-500`):
1. `DivFamZar.exists_certified_away_rep F₀` (`:79`, same file) — step 1, the certificate cover.
2. `divFamEps_exists_frameCover hπ g hO hχ r₁ r₂ b₁ b₂ (DivFam.mk (Gl l))` (`AlgebraicJacobian/Picard/DivSchemeFrameCover.lean:456`) — per-representative ε frame cover. **This is the genuinely two-chart input.**
3. `IsLocalization.Away.associated_sec_fst` and `span_range_num_mul_eq_top` — the numerator trick assembling the composite span-⊤ family.
4. `exists_certChart_piece` (`DivRepClassifyZarKit.lean:343`, `private`) — per-piece transport to the canonical carrier along `IsLocalization.algEquiv`; internally uses `map_window_frame_toSubmodule`, `Module.Grassmannian.map_comp`, `DivFam.toZar_mapAlg`, `DivFamZar.mapAlg_comp`.

Note `exists_certChart_piece` is `private`, so it is invisible to name search from outside the file (memory `private-hides-a-declaration-from-search`).

## 2. The ε layer on the widened side

**2a. A widened ε map EXISTS.** `AlgebraicJacobian/Picard/DivisorFamilyAffFraming.lean:88`:

```lean
noncomputable def eps (F : CertifiedDivisorFamilyAff C R g) :
    Submodule R (R ⊗[k]
        ↥(Scheme.divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
      × Submodule R (R ⊗[k] ↥(Scheme.divisorSections k
          ((windowM_choice pi hpi g + windowS_choice pi hpi g) • fiberWeilDivisor pi) ⊤)) :=
  (divisorWindow F.eqns (relThetaPairH1_windowM C pi hpi g),
   divisorWindow F.eqns (relThetaPairH1_windowMS C pi hpi g))
```

in namespace `CertifiedDivisorFamilyAff`, with `eps_fst`/`eps_snd` as `rfl` simp lemmas at `:129`/`:137`. It takes `CertifiedDivisorFamilyAff` (a representative, not a class): there is **no** widened analogue at the quotient `DivFamZarAff`, because that would need `divisorWindow_eq_of_divEq` lifted through `divFamZarAffSetoid` — that lemma exists (`DivisorFamilyWindow.lean:123`) and is `DivEq`-only, so the lift is available but is not written.

**The reviewer's claim that the ε/Theta framing layer is entirely missing on the widened side is wrong on the ε half and right on the framing-achievement half.** `DivisorFamilyAffFraming.lean` is in the root (`AlgebraicJacobian.lean:618`) and is sorry-free.

**2b. What the widened Theta layer proves.** Both `DivisorFamilyAffTheta.lean` (925 lines) and `DivisorFamilyAffThetaTyping.lean` (557 lines) contain **zero** Grassmannian, `PairChartRing`, `pairTaut*`, `pairChartMap`, `glueData`, or `divFamEps` content. Their "Theta" is the Θ-cocycle glued-submodule / colength-evaluation layer, a different object from the ε/Grassmannian framing. Full inventory:

`DivisorFamilyAffTheta.lean` — the Θ-layer over `AffAdaptation A` indexed by a `ChartTyping τ`:
- `:153` `pinnedChartOfSide_eq` — the two chart spellings agree, `rfl` per `Bool`.
- `:159` `piece_le_relPinnedChart`, `:164` `pieces_inf_le_relPinnedChart_inf` — a typed piece sits in its assigned pinned chart, and pairwise on overlaps.
- `:174` `thetaOvlUnit` — the overlap comparison unit from the two assigned sides; `:184` `relThetaSideUnit_zero`, `:200` `thetaOvlUnit_zero` — it is `1` at exponent `0`.
- `:209` `thetaDeltaRight`, `:219` `thetaGluedSubmodule`, `:223` `mem_thetaGluedSubmodule_iff`, `:237` `ThetaGlued` — the Θ-twisted equalizer of the per-piece colength product.
- `:245` `germ_eqn_span_eq_stalkIdeal` — the piece equation's germ spans the divisor's stalk ideal.
- `:268` `thetaPieceEval`, `:274` `thetaEval`, `:278` `thetaEval_apply`, `:311` `thetaEval_mem`, `:324` `thetaGluedEval`, `:328` `thetaGluedEval_coe`, `:332` `ker_thetaGluedEval_eq_ker` — the Θ-twisted colength evaluation and that it lands in the equalizer.
- `:289` `toOvlLeft_mk`, `:296` `toOvlRight_mk` — `rfl` restriction identities.
- `:347` `gluedSubalgebra`, `:365` `mem_gluedSubalgebra_iff`, `:370` `gluedSubalgebraEquiv` — the untwisted equalizer as an `R`-subalgebra.
- `:384`-`:459` (UnitTwist) `unitDeltaRight`, `unitGluedSubmodule`, `mem_unitGluedSubmodule_iff`, `unitGluedSubmodule_one`, `unitGluedSubmodule_thetaOvlUnit`, `mul_mem_unitGluedSubmodule`, `unitGluedOver`, `mem_unitGluedOver_iff` — the equalizer for an arbitrary unit cocycle and its multiplicativity.
- `:479`-`:515` (Sections) `relFiberCoordSidePow` + 2 simp lemmas, `thetaSectionSide`, `thetaSectionSide_of_side_eq/_ne` — the manufactured per-side theta section.
- `:533`-`:601` (Pairing) `thetaSpan`, `thetaInvSpan`, `mem_thetaSpan_iff`, `mem_thetaInvSpan_iff`, `thetaSpan_mul_thetaInvSpan_le_one` (the automatic `≤` half), `IsThetaPaired` (a **`Prop` defined and not proved**), `isThetaPaired_of_one_mem`, `isThetaPaired_zero` (satisfiability probe at `a = 0`).
- `:658` `isEmpty_chartTyping_of_straddling` — **`ChartTyping C R π D` is EMPTY on a cover with a straddling piece.** This makes every declaration above vacuous on exactly the divisors I-0492 exists for. The file's own docstring says so (`:15-25`, `:626-656`), and notes at `:653` that the tree's only `ChartTyping` producer is `FinCoverData.toChartTyping` (`DivisorFamilyAffCover.lean:255`), the migration *from* the chart-typed carrier.
- `:675` `germ_relThetaResSide_eq`, `:691` `germ_val_mem_stalkIdeal_of_forall_side`, `:717` `germ_val_mem_stalkIdeal_of_thetaEval_eq_zero` — the germ machinery.
- `:813` `ker_thetaGluedEval` — kernel of the widened Θ evaluation = `d.vanishingSubmodule … (relThetaCocycle C R π a)`.
- `:884` `windowCarve`, `:899` `ker_windowCarve` (`= divisorWindow d hH1`), `:905` `windowCarve_surjective` (conditional), `:914` `windowQuotEquiv` (conditional on surjectivity, **not proved**).

`DivisorFamilyAffThetaTyping.lean` — the same layer re-indexed on a chart-free datum:
- `:99` `ThetaTrivData` — structure with fields `read`, `unit`, `matching`, `germ_read`; no `pieces j ≤ …` constraint.
- `:142` `ChartTyping.thetaTrivData` — the old index maps in.
- `:199`-`:301` `le_iSup_top_inf_relPinnedChart`, `existsUnique_glueThetaZero`, `glueThetaZero`, `resHom_glueThetaZero`, `glueThetaZero_eq_of_forall`, `glueThetaZeroHom`, `AffCoverData.thetaTrivDataZero` — `ThetaTrivData D 0` inhabited for **every** widened cover.
- `:343` `nonempty_thetaTrivData_and_isEmpty_chartTyping` — the separation: on a straddling cover the new index is inhabited, `ChartTyping` empty.
- `:371`-`:474` `trivDeltaRight`, `trivGluedSubmodule`, `mem_trivGluedSubmodule_iff`, `TrivGlued`, `trivPieceEval`, `trivEval`, `trivEval_apply`, `trivEval_mem`, `trivGluedEval`, `ker_trivGluedEval_eq_ker`, `germ_read_mem_stalkIdeal_of_trivEval_eq_zero`, `ker_trivGluedEval` — the whole Θ layer on the chart-free index, kernel identified.
- `:528`-`:546` `trivWindowCarve`, `ker_trivWindowCarve` (`= divisorWindow d hH1`), `trivWindowCarve_surjective`, `trivWindowQuotEquiv` (conditional on the unproved surjectivity).

**2c. Widened ε pair ↔ Grassmannian pair-chart framing: ONE declaration, not zero** — `CertifiedDivisorFamilyAff.IsPairChartFramed`, `DivisorFamilyAffFraming.lean:112`:

```lean
def IsPairChartFramed (F : CertifiedDivisorFamilyAff C R g)
    (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
    (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] R) : Prop :=
  (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule
      = Submodule.map (LinearMap.baseChange R b₁.equivFun.toLinearMap)
        (F.eps hpi g).1
    ∧ (Module.Grassmannian.map w (pairTautSnd k g r₁ r₂ i j)).toSubmodule
      = Submodule.map (LinearMap.baseChange R b₂.equivFun.toLinearMap)
        (F.eps hpi g).2
```

It is a `Prop` **definition only**: it has **zero consumers and zero producers** in the tree. No theorem asserts it holds, no cover-existence statement uses it. Greps run:

```
grep -rniE "pairchartring|pairtautfst|pairtautsnd|pairchartmap|glueData" AlgebraicJacobian/Picard/DivisorFamilyAff*.lean
  → only DivisorFamilyAffFraming.lean:113,114,115,118 (the def) + AffAwayRep.lean:28 (prose)
grep -rniE "pairchart|pairtaut|glueData|grassmannian|divFamEps|PairChart" \
    DivisorFamilyAffTheta.lean DivisorFamilyAffThetaTyping.lean
  → DivisorFamilyAffTheta.lean:44 only (prose citing divFamEps_eq_of_le)
grep -rniE "isPairChartFramed|framedAff|affFramed|pairChartFramedAff|exists_certChartCoverAff|
            existsCertChartCoverAff|certChartCoverAff|affCertChartCover"
  → only the 3 AffFraming/AffAwayRep hits above
grep -rniE "^(noncomputable |private )*(def|theorem|lemma|abbrev|instance) +[A-Za-z0-9_.']*
            (aff[A-Za-z0-9_.']*eps|eps[A-Za-z0-9_.']*aff)"     → ZERO
grep -rniE "divFamEpsAff|epsAff|affEps|EpsAff"                  → ZERO
grep -rniE "^…(def|theorem|lemma|abbrev|instance)[^:]*(divFamZarAff|CertifiedDivisorFamilyAff)
            [^:]*(eps|Eps|frame|Frame|taut|Taut|chart|Chart)"   → ZERO
grep -rniE "IsDivRepClassifyAff|divRepClassifyAff|divClassifyZarAff|isDivRepClassify.*Aff" → ZERO
file-level cross-check: of all files mentioning pairTaut*/PairChartRing/pairChartMap, exactly
  TWO also mention a widened carrier: DivisorFamilyAffFraming.lean, DivisorFamilyAffAwayRep.lean
```

So: **ZERO widened *frame-existence* statements** (no widened `divFamEps_exists_frameCover`, no widened `exists_certChartCover`), **ZERO widened `IsDivRepClassify`**, but **one widened framing *clause*** and **one widened ε map**, both landed and sorry-free.

## 3. `divFamEps` itself

`AlgebraicJacobian/Picard/DivisorFamilyWindow.lean:260`:

```lean
noncomputable def divFamEps (g : ℕ) (F : DivFam C R π g) :
    Submodule R (R ⊗[k]
        ↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤))
      × Submodule R (R ⊗[k] ↥(Scheme.divisorSections k
          ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤)) :=
  (F.window (relThetaPairH1_windowM C π hπ g),
   F.window (relThetaPairH1_windowMS C π hπ g))
```
with `divFamEps_mk` (`:269`) `= (divisorWindow G.eqns …, divisorWindow G.eqns …)`, by `rfl`.

**Chart-typed inputs:** exactly one — `F : DivFam C R π g`, the chart-typed quotient (`DivisorFamily.lean:472`, `Quotient (divFamSetoid C R π n)` over `CertifiedDivisorFamily`). Everything else (`π`, `hπ`, the windows) is shared. `DivFam.window` (`:133`) is `Quotient.lift (fun G => divisorWindow G.eqns hH1) (divisorWindow_eq_of_divEq …)`, and `divisorWindow` (`:103`) is

```lean
Submodule.comap (relThetaWindowEquiv C R π a hH1).toLinearMap
  (d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
    (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a))
```

**Its VALUE depends only on `d = G.eqns`, `hH1`, and the P¹ two-chart cover `relCover C R (fiberTwoCover π)`** — not on the divisor's own cover, adaptation, or certificate. There is a `V₀`/`V₁` dependence, but it is the *twist's* two-chart model of the line bundle, not a typing of the divisor's pieces (the distinction `DivisorFamilyAffThetaTyping.lean:20-25` makes explicitly). So what would have to change for a widened input is only the carrier of the `eqns` field — which is exactly what `CertifiedDivisorFamilyAff.eps` does, and its `eps_fst`/`eps_snd` are `rfl`. The `rfl` proofs are the measurement that the widening is invisible to the value.

## 4. Chart↔widened maps: all one-directional, chart → widened

| declaration | file:line | direction |
|---|---|---|
| `DivisorAdaptation.toAff` | `AlgebraicJacobian/Picard/DivisorFamilyAffCompare.lean:65` | chart → widened |
| `DivisorAdaptation.isCertified_toAff` | `DivisorFamilyAffCompare.lean:201` | chart → widened (all 7 certificate clauses migrate) |
| `CertifiedDivisorFamily.toAff` | `DivisorFamilyAffCompare.lean:230` | chart → widened, `toAff_eqns` is `rfl` (`:238`) |
| `isLocallyCertifiedAff_of_isLocallyCertified` | `DivisorFamilyAffCompare.lean:~249` | chart → widened |
| `DivFamZar.toAff` | `DivisorFamilyAffCompare.lean:262` | chart → widened |
| `DivFamZarAff.picClass_toAff` | `DivisorFamilyAffCompare.lean:277` | chart → widened (class preserved) |
| `divFunctorToAff : divFunctor C π n ⟶ divFunctorAff C n` | `DivisorFamilyAffFunctorCompare.lean:91` | chart → widened |
| `FinCoverData.toAffCoverData` / `.toChartTyping` | `DivisorFamilyAffCover.lean:224` / `:255` | chart → widened |
| `DivFamZar.toAff_mapAlg` / `toAff_mapAlgHom` | `DivisorFamilyAffMapAlg.lean:459` / `DivisorFamilyAffFace.lean:181` | naturality of the above |

**No widened → chart map exists in either direction of the greps I ran** (arrow-form and colon-form both returned nothing). `CertifiedDivisorFamilyAff.toZarAff` (`DivisorFamilyAffGlueZarKit.lean:586`) is widened rep → widened class, not a crossing. `divRepAffinePullback_ofChartClause` (`DivRepAffPullClause.lean:469`) and `JacobianData.ofCharts*` are unrelated to this carrier pair.

**Nothing produces a chart framing from widened data.**

## 5. `forall_not_isCertified_of_straddling`

`AlgebraicJacobian/Picard/DivisorFamilyAffStrict.lean:127`, verbatim:

```lean
theorem forall_not_isCertified_of_straddling
    {d : (relCurve C R).LocalEquations}
    (hconn : _root_.IsPreconnected d.supportLocus)
    {x y : relCurve C R} (hx : x ∈ d.supportLocus) (hy : y ∈ d.supportLocus)
    (hx₀ : x ∉ ((relCover C R (fiberTwoCover pi)).V₀ : Set (relCurve C R)))
    (hy₁ : y ∉ ((relCover C R (fiberTwoCover pi)).V₁ : Set (relCurve C R))) :
    ∀ (A : DivisorAdaptation C R pi d) (n : ℕ), ¬ A.IsCertified n :=
  fun A _ => A.not_isCertified_of_isPreconnected_of_witnesses hconn hx hy hx₀ hy₁
```

Section binders (`:109-111`): `{k} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom]`, `{R} [CommRing R] [Algebra k R]`, `{pi : C.left ⟶ P1 k} [IsFinite pi]`.

**What it refutes:** for one fixed local-equation system `d` whose support locus is preconnected and contains a point off `V₀` and a point off `V₁`, it refutes the existence of a chart-typed certificate — quantified over **all** `DivisorAdaptation C R pi d` and **all** degrees `n`. No leak hypothesis, no field-size hypothesis, no `IsNoetherianRing`.

**What it does not refute:** it says nothing about widened adaptations. Its companion `exists_affAdaptation_isCertified_of_straddling` (`:144`) gives a widened certificate for the same `d` under the Stacks `0B8B` inputs, and `isCertified_affine_and_not_isCertified_chart` (`:186`) conjoins them.

**On the claim that it blocks any widened→chart map:** it blocks a *total* map `IsLocallyCertifiedAff → IsLocallyCertified` at the level of local-equation systems, hence a total `DivFamZarAff → DivFamZar`, **conditionally**: the file itself states at `:44-63` that the joint hypothesis set is **not** exhibited in this tree (no `Sym^g C`, ADDENDUM 4 §4.5), that the existing `n = 0` non-vacuity witnesses contradict `hx`/`hy` (a straddling divisor has nonempty support), and that the theorems are therefore "not certified non-vacuous" per I-0442 trap (c). So the block is a conditional refutation with no Lean-side inhabitant. `DivisorFamilyAffTheta.lean:40` states the block flatly ("there is no map `DivFamZarAff → DivFamZar` and there cannot be") without that qualification.

## Bearing on the widened uniqueness theorem

The two inputs you named split cleanly:

- **(b) `divScheme_hom_ext`** (`AlgebraicJacobian/Picard/DivScheme.lean:172`) is `{T : Scheme.{u}} (u v : T ⟶ DivScheme …) (h : u ≫ divSchemeι = v ≫ divSchemeι) : u = v`. It mentions no divisor carrier at all. Free for the widened statement.
- **(a) `exists_certChartCover`** splits into two halves whose widened status differs sharply:
  - step 1 (certificate cover) is **already landed widened**: `DivFamZarAff.exists_certified_away_rep`, `AlgebraicJacobian/Picard/DivisorFamilyAffAwayRep.lean:84`, plus `_of_mk` at `:101`, sorry-free, in root (`AlgebraicJacobian.lean:615`);
  - the ε-framing half is **not** landed: no widened `divFamEps_exists_frameCover`, so no widened `exists_certChartCover`. Its *clause* is expressible (`IsPairChartFramed`) and its *value* is defined (`eps`), but nothing derives that the framing is achievable over each away piece.

A widened `IsDivRepClassify` predicate does not exist either (`grep → ZERO`), so a widened uniqueness statement would need that written first. The chart-typed uniqueness proof (`DivRepClassifyZar.lean:168-200`) uses only `hZ`, `ci`, `cj`, `cw`, `hcw₁`, `hcw₂` from the cover output — it discards nothing — so a widened uniqueness theorem is exactly as strong as a widened `exists_certChartCover`, and no weaker.

## What I did NOT check

- **I did not run `lake build` or any elaboration.** Every statement above is read from source. I have not verified that `CertifiedDivisorFamilyAff.eps`, `IsPairChartFramed`, or `DivFamZarAff.exists_certified_away_rep` currently elaborate at HEAD, nor that the files are green — only that they contain no `sorry`/`admit`/`axiom` and are imported from `AlgebraicJacobian.lean`. Per memory `stale-imports-fake-probe-success` and `cited-names-need-check-not-grep`, source presence is not import-closure presence: I did not check whether a hypothetical widened uniqueness file could see both `DivisorFamilyAffFraming.lean` and `DivRepClassifyZarKit.lean` without an import cycle.
- **I did not measure git state.** All reads are of the working tree, not `git show HEAD:`. Per memory `verify-board-at-head-not-worktree`, another lane may have changed any of these files.
- **I did not census the whole tree for a widened frame-existence theorem under a name I did not guess.** My absence claims for 2c rest on the greps quoted (case-insensitive, lowercase-suffix shapes, and a file-level both-carriers cross-check) plus one `horizon search` semantic query — not on an exhaustive declaration census. Per memory `absence-claims-rest-on-scans-not-censuses` these are scans. In particular a `private` widened framing lemma inside an unrelated file would be invisible to name search, exactly as `exists_certChart_piece` is.
- **I did not read `DivSchemeFrameCover.lean`'s proof of `divFamEps_exists_frameCover`** beyond its statement and the `exists_frame_chart_at_prime` call at `:471`. I therefore cannot say how much of that proof's chart-dependence is essential versus incidental — which is the load-bearing unknown for pricing a widened restatement, and I am not pricing it.
- **I did not verify the reviewer's framing claim against whatever document they wrote it in**; I measured the tree.
- **I did not check whether `divisorWindow`'s `relCover C R (fiberTwoCover π)` dependence is itself a fixed-pair confinement in the I-0492 sense.** I report the distinction the tree draws (`DivisorFamilyAffThetaTyping.lean:20-25`: twist model vs piece typing) without independently auditing it.
- **I did not check the 5 open protections** (`I-1222`, `I-0074`, `I-0838`, +2) that the `horizon` CLI banner flagged, nor the 346 unread inbox items, for anything bearing on this measurement.
