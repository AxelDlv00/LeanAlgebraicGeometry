# SPEC DD-2 — divFam functoriality + the Zariski sheaf property (`AJCR.w4-rep.datum.dat-d.dd2`)

*2026-07-17, Fable prover-architect. BINDING parent: `informal/dat-d-worksheet.md` §1.1
(D1), §5 DD-2 row, Discipline; `informal/spec-dd-1.md` §1 (frozen carrier), §3 stages
(c)/(e) rows; consumers: `informal/spec-dd-r.md` §3 DDR-9 + §4 gating row ("DD-2 gates
only DDR-9's general-test statement"), §6 consumer rows; the DAT-2 pattern files
`Picard/PicEtAffZariskiSep.lean` / `PicEtAffZariskiGlue.lean` / `Pic0ZariskiSheaf.lean`.
Evidence read in full this pass: `Picard/DivisorFamily.lean` (carrier, `:230`
`DivisorAdaptation`, `:384` `CertifiedDivisorFamily`, `:404` `DivFam`),
`Picard/DivisorFamilyMapAlg.lean` (stage-(c) close, the recorded pt-transport seam,
`divEq_pullback:73`), `Picard/DivisorFamilyPullbackMap/Overlap/Cert/Glued.lean` (the
landed (c1)–(c4) transports — all module-level, anchor-free),
`Picard/DivisorFamilyExtraction.lean:54` (the only anchored construction site),
`Picard/DivisorClass.lean:112` (`LocalEquations`, `ratio_isUnit` on FULL overlaps),
`Picard/DivisorStalkIdeal.lean` (`mem_span_singleton_of_forall_germ` — the
regularity-gluing workhorse). Anchor-field usage grep (this pass): `pt`/`piece_le`/
`unit`/`eqn_eq` are consumed ONLY in `DivisorFamily.lean` (`eqn_regular:252`),
`DivisorFamilyPullbackMap.lean` (`:148–150`, `:193–235`), `DivisorFamilyTheta.lean`
(`:326–329`), `DivisorFamilyFieldDegree.lean` (`:172–182`), `DivisorFamilyMapAlg.lean`
(rewritten by this spec), `DivisorFamilyExtraction.lean` (construction). The DD-4
in-flight files (`DivisorTheta*`) and the Pullback/Cert/Glued transports consume NO
anchor field. `ofWitness`/`BaseChangeWitness`/`mapAlgOfSurjective` have ZERO consumers
outside `DivisorFamilyMapAlg.lean`.*

## 0. The adjudication: the pt-transport seam is a carrier defect, not a proof gap

DD-1 stage (c) closed with `DivFam.mapAlgOfSurjective` only, recording the
unconditional `mapAlg` as the open **pt-transport seam** (`DivisorFamilyMapAlg.lean`
module docstring). DDR-9 (`spec-dd-r.md` §3.8) consumes `mapAlg` along ARBITRARY test
maps (homEquiv forward + naturality), the stage-(e) vehicle consumes it along
restrictions `Γ(U) → Γ(U')` (never surjective on curve points), and DD-2's
componentwise sheaf statements consume it along localizations. This pass adjudicated
every representative-side escape and CLOSED them all:

- **Selector re-pointing is dead.** Building the pulled representative with cover
  members = pulled pieces via a selector `sel : C_{R'} → index` fails: `piece_le`
  needs, per piece `j`, an anchor `y` with `pieces (sel y) ⊇ pieces j`; for a piece
  contained in the union of two ⊆-incomparable pieces every candidate anchor selects a
  non-containing member. Chain-partition/Hall repairs exist set-theoretically for some
  configurations but not all, and are disproportionate in Lean regardless.
- **Extraction + certificate transport is dead.** `exists_divisorAdaptation` gives an
  anchored adaptation of the pulled system, but its pieces are Z-blind basic opens:
  (c1) is NOT refinement-stable — for `Z = V(f)` finite flat over `Spec R`, the
  section ring of `Z ∩ Q` over a refined piece `Q` need not be `R`-finite (e.g.
  `Z ≅ Spec k[x]` finite over `R = k[t]` via `t = x²`; remove one point of a fibre
  from `Q`: `Γ = k[x][1/(x−1)]` is not `k[t]`-finite). Certificates do not transport
  along arbitrary re-adaptations; they DO transport along the pulled pieces (landed).
- **Fibre anchors are genuinely absent** for non-surjective comparisons (the seam's
  own counterexample stands).

**VERDICT: keep the pulled pieces, delete the anchors.** The anchor fields
`pt`/`piece_le`/`unit`/`eqn_eq` overshoot the mathematics: worksheet §1.1 (D1) demands
only that the adaptation *refines `d` up to units so that `picClass` is unchanged*.
The faithful point-free form is a pointwise-unit clause (the `DivEq` spelling, one
open lower), which pulls back along ARBITRARY morphisms by exactly the landed
`divEq_pullback` pattern. This is a **sanctioned spelling deviation** re-derived from
the worksheet (as spec-dd-1 §5 requires): same divisor-refinement content, same
apparatus, strictly weaker stored data. All four anchor-consuming proofs are germ- or
generic-point-level and re-derive from the pointwise clause (audit in §1 below).

## 1. Stage S1 — the carrier surgery (`Picard/DivisorFamily.lean`, in place)

**(S1a) The field swap.** In `structure DivisorAdaptation` replace the four fields
`pt`, `piece_le`, `unit`, `eqn_eq` by ONE Prop field:

```
/-- The equations refine `d` pointwise up to units: on the overlap of each piece with
any member of `d`'s cover, `f_j` and `d`'s equation differ by a unit. Point-free (the
`DivEq` spelling), so it pulls back along arbitrary morphisms — the resolution of the
DD-1 pt-transport seam. -/
eqn_rel : ∀ (j : toFinCoverData.index) (y : relCurve C R),
  ∃ u : Γ(relCurve C R, toFinCoverData.pieces j ⊓ d.cover.opens y)ˣ,
    ((relCurve C R).presheaf.map (homOfLE inf_le_left).op).hom (eqn j)
      = (u : Γ(relCurve C R, toFinCoverData.pieces j ⊓ d.cover.opens y))
        * ((relCurve C R).presheaf.map (homOfLE inf_le_right).op).hom (d.eqn y)
```

(Quantify over ALL `y` — the empty overlap is the zero ring, where the clause is
trivial; no membership side condition.)

**(S1b) The compatibility constructor** — old callers change one token:

```
def DivisorAdaptation.ofAnchors (D : FinCoverData C R π)
    (eqn : ∀ j : D.index, Γ(relCurve C R, D.pieces j))
    (pt : D.index → relCurve C R)
    (piece_le : ∀ j, D.pieces j ≤ d.cover.opens (pt j))
    (unit : ∀ j, Γ(relCurve C R, D.pieces j)ˣ)
    (eqn_eq : ∀ j, eqn j = unit j * res (d.eqn (pt j))) :
    DivisorAdaptation C R π d
```

`eqn_rel` derivation: restrict `eqn_eq j` to `pieces j ⊓ d.cover.opens y`
(`res_res`), then rewrite `d.eqn (pt j)` to `d.eqn y` by `d.ratioUnit (pt j) y`
restricted along `pieces j ⊓ opens y ≤ opens (pt j) ⊓ opens y` (valid since
`pieces j ≤ opens (pt j)`); `u := unitsRestrict … (unit j) * unitsRestrict …
(d.ratioUnit (pt j) y)` — the `DivEq.trans` calc pattern (`DivisorFamily.lean:88`)
verbatim.

**(S1c) Re-derived lemmas** (statements UNCHANGED where they exist):

- `eqn_regular` (`:252`): at `z ∈ pieces j` use `eqn_rel j z` — `z ∈ pieces j ⊓
  d.cover.opens z`; germ the relation; unit germ + `d.regular z z` nonzerodivisor.
- **NEW** `eqn_ratio_isUnit` (the section-level piece-to-piece ratio, needed by S5 and
  generally useful): `∀ i j, ∃ w : Γ(pieces i ⊓ pieces j)ˣ, res (eqn i) = w * res
  (eqn j)`. Route: local cofactors from `eqn_rel i y`/`eqn_rel j y` at each
  `y ∈ pieces i ⊓ pieces j` (compose the two units through `d.eqn y`); uniqueness of
  cofactors from regularity (`eqn_restrict_mem_nonZeroDivisors`); glue by
  `X.sheaf.existsUnique_gluing'` — the `existsUnique_eqn_mul_eq` pattern
  (`DivisorThetaDatum.lean`); unit-ness is local (both one-sided cofactors glue and
  multiply to 1 by regularity). If the DD-4 lane's `eqnRatio` already covers this
  shape, CONSUME it — check at build time, do not duplicate.

**(S1d) Fix sites** (complete list, from the grep of record):

| file | fix |
|---|---|
| `DivisorFamilyExtraction.lean:54` | end of proof: build via `.ofAnchors D pt hle eqn (fun _ => 1) …` (unit `1`, same witnesses) |
| `DivisorFamilyPullbackMap.lean:148–150` | regularity of the adaptation equations: use the new `eqn_regular` (or inline `eqn_rel` + germ) |
| `DivisorFamilyPullbackMap.lean:193–235` | the pulled-equation stalk-unit comparison: replace the `eqn_eq`+`ratioUnit (A.pt j) (f.base y)` composite by `eqn_rel j (f.base y)` pulled through `appLE` — ONE clause instead of two, same `germ_stalkMap` seam |
| `DivisorFamilyTheta.lean:326–329` | `germ_eqn_span_eq`: use `eqn_rel j z` at the point `z` itself (germ of the relation + `Ideal.span_singleton_mul_left_unit`), replacing `eqn_eq` + `d.germ_eqn_span_eq (A.pt j)` |
| `DivisorFamilyFieldDegree.lean:172–182` | the generic-point reading: use `eqn_rel j η` (with `η ∈ pieces j ⊓ opens η` via the piece containing `η`); `germGenericUnits` of the new unit; `d.presentation.elem η` replaces `elem (A.pt j)` — then `ordZ_elem_eq` at `η`'s member. If the surrounding proof pins `elem (A.pt j)` elsewhere, rewrite through `d.ratioUnit`-invariance of `ordZ` exactly as the current lines 178–182 already do |
| `DivisorFamilyMapAlg.lean` | REWRITTEN — §2 |

NO other file changes (verified: Pullback/Cert/Glued/Overlap, all `DivisorTheta*`,
Window, Field, Backward, FieldEquiv consume only `pieces`/`eqn`/apparatus/derived
lemmas). `CertifiedDivisorFamily`, `DivEq`, `divFamSetoid`, `DivFam`, `picClass`,
apparatus (`colength`…`IsCertified`) — ALL UNCHANGED.

## 2. Stage S2 — total `mapAlg` (`Picard/DivisorFamilyMapAlg.lean`, rewrite)

Keep: `divEq_pullback` (`:73`, untouched), `appLE_eqn_congr`. Delete:
`BaseChangeWitness`, `ofSurjective`, `witness_piece_le`, `ofWitness`,
`isCertified_ofWitness`, `baseChangeOfSurjective`, `mapAlgOfSurjective` (+ its two
lemmas) — zero external consumers (grep of record). Replace by:

- `DivisorAdaptation.pullback (R') (hproj) : DivisorAdaptation C R' π
  (A.pulledEquations R' hproj)` — `toFinCoverData := A.toFinCoverData.baseChange R'`,
  `eqn := A.pulledEqn R'`, `eqn_rel := ` the pulled clause: for `(j, y')` the target
  overlap is `relCurveMap ⁻¹ᵁ (pieces j ⊓ d.cover.opens (f.base y'))`
  (`pieces_baseChange` + preimage-inf), and `eqn_rel j (f.base y')` transports through
  `Scheme.Hom.unitsAppLE` — the `divEq_pullback` proof (`:82–114`) is the template,
  clause for clause.
- `DivisorAdaptation.isCertified_pullback : A.IsCertified n → (A.pullback R'
  hc.projective_colength).IsCertified n` — the SAME seven-field assembly as the
  deleted `isCertified_ofWitness` (`:221–235`): the apparatus of `pullback` is
  field-for-field definitionally the pulled apparatus (`baseChange` cover data +
  `pulledEqn` — identical to `ofWitness`'s), so the landed
  `finite_/projective_pulledColength`, `finite_/projective_/rankAtStalk_pulledGlued`,
  `flat_pulledCokerIncl/Diff` discharge it verbatim.
- `CertifiedDivisorFamily.mapAlg (F) : CertifiedDivisorFamily C R' π n` (pulled
  eqns/adaptation/certificate), `DivFam.mapAlg : DivFam C R π n → DivFam C R' π n`
  (`Quotient.lift`, descent by `divEq_pullback`), `@[simp] DivFam.mapAlg_mk`,
  `DivFam.picClass_mapAlg` (via the landed `picClass_pulledEquations`).

**Functor laws** (same file if ≤ 500 lines, else `Picard/DivisorFamilyMapAlgLaws.lean`):

- `DivFam.mapAlg_id : mapAlg R (algebra ℐ = id tower) F = F` — at representative
  level: `pulledEquations` along `relCurveMap C R R`; establish DivEq to the original
  via `𝒲 := (d.cover.pullback f) ⊓ d.cover`-style refinement and the `appLE`/id
  collapse (`relCurveMap C R R` is the comparison of the identity test map — if the
  tree lacks `relCurveMap_id`, prove the DivEq directly from `appLE` at
  `Scheme.Hom.appLE_id`-shaped simp lemmas; the class-level statement is what matters).
- `DivFam.mapAlg_comp` (tower `R → R' → R''`, `[IsScalarTower R R' R'']`):
  `mapAlg R'' ∘ mapAlg R' = mapAlg R''` — representative level: two pulled systems
  with EQUAL covers (`preimage_comp`) and `appLE`-composite equations
  (`Scheme.Hom.appLE_appLE`/`map_appLE`); needs the comparison-composition lemma
  (`relCurveMap C R' R'' ≫ relCurveMap C R R' = relCurveMap C R R''` — expected in the
  DAT-1 (1d) plumbing; if absent, prove via the universal property of the pullback
  spelling, S-sized). DivEq with unit `1`.

## 3. Stage S3 — the vehicle (`Picard/DivisorFamilyVehicle.lean`, spec-dd-1 §1e verbatim)

`divFam n T := {s : Π U : T.left.affineOpens, DivFam C Γ(T.left, U.1) π n //
∀ {U V} (h : V.1 ≤ U.1), DivFam.mapAlg (Over.resAlgHom-tower) (s U) = s V}` on the
`PicEt.lean:9–36` pattern (same `Over.sectionsAlgebra` instances), `Type u`;
`divFamAffineEquiv : divFam n (overSpec k R) ≃ DivFam C R π n` (top-open collapse,
`PicEt` precedent); restriction functoriality `divFam.map` along `T' ⟶ T` in
`Over (Spec k)` via `mapAlg` + `mapAlg_comp` (the `PicEtMap` pattern — morphism-level
gluing beyond restrictions is S6's business, NOT S3's).

## 4. Stage S4 — Zariski separation (`Picard/DivisorFamilyZariskiSep.lean`)

Mirror `PicEtAff.eq_of_away_eq` (`PicEtAffZariskiSep.lean:137`). Pack: `{ι : Type u}
[Finite ι] (g : ι → R) (hg : Ideal.span (Set.range g) = ⊤)`, localizations
`Localization.Away (g i)` with the standing tower instances.

- **Keystone `DivFam.eq_of_away_eq`**: `F G : DivFam C R π n`, `(∀ i, mapAlg
  (Localization.Away (g i)) F = mapAlg _ G) → F = G`.
- Route (equation rigidity — worksheet DD-2 row): representative level, `DivEq` is
  Zariski-local on the curve. The comparisons `relCurveMap C R (Away (g i))` are open
  immersions onto the charts' `g i`-loci covering `relCurve C R` (the pieces of the
  two pinned charts at the pulled `g i` — `relSectionsMap_basicOpen`/DAT-1 (1d-ii)
  plumbing; `CechPicClopenSep`/`OpenImmersionUnits` hold the immersion-transport kit).
  `DivEq (pullback dF) (pullback dG)` over each `Away (g i)` gives pointwise units on
  refinements; transport each along the immersion (units and refinements transport —
  `OpenImmersionUnits`) and assemble the common refinement of `dF.cover ⊓ dG.cover`
  pointwise: `DivEq` demands NO cocycle across points, so locality is a pointwise
  patch — no gluing lemma needed for separation.
- Corollary `DivFam.eq_of_localization_eq` at arbitrary `IsLocalization.Away`
  carriers if the Away-transport friction demands a named bridge (S-sized, optional).

## 5. Stage S5 — Zariski gluing (`Picard/DivisorFamilyZariskiGlueKit.lean` + `…Glue.lean`)

THE HEART. Mirror `PicEtAff.exists_mapAlg_eq_of_compat` (`PicEtAffZariskiGlue.lean`).

- **Keystone `DivFam.exists_glue_of_away_compat`**: data `(g : ι → R)` finite,
  span-⊤, classes `F i : DivFam C (Localization.Away (g i)) π n` with pairwise
  compatibility `mapAlg (Away (g i * g j)) (F i) = mapAlg _ (F j)` (both routes into
  the overlap localization; spelling via the tree's `Away`-tower instances as in
  `PicEtAffZariskiGlue`); conclusion `∃ F : DivFam C R π n, ∀ i, mapAlg _ F = F i`.
  (Uniqueness is S4.)
- Divisor assembly: representatives `(d_i, A_i)`; the curve opens `C_{g_i} :=`
  image-loci of the open immersions `ι_i : relCurve C (Away (g i)) → relCurve C R`
  cover `relCurve C R`. Build `d : LocalEquations (relCurve C R)` POINTWISE: at `y`
  pick `i(y)` with `y ∈ C_{g_i}` (choice), member := `ι_{i(y)}`-image of
  `d_{i(y)}.cover.opens (ι⁻¹ y)`, eqn := transported equation (immersion section iso;
  `OpenImmersionUnits` kit). `regular` transports along stalk isos. `ratio_isUnit`
  across `x, y` with `i(x) ≠ i(y)`: the overlap sits in `C_{g_i g_j}`, where
  compatibility gives `DivEq` — pointwise units on a refinement; upgrade to the FULL
  member-overlap unit by the regularity-gluing pattern (unique local cofactors ⟹
  `existsUnique_gluing'` ⟹ global cofactors both ways ⟹ unit) — the S1c
  `eqn_ratio_isUnit` engine, stated once in the Kit for reuse.
- Adaptation of `d` over `R`: pieces := the `A_i`-pieces cleared of denominators
  (basic opens of `Away (g i)`-charts are basic opens of the `R`-charts at
  `g̃_i^N · h̃` — `relSectionsMap_basicOpen` + `IsLocalization.Away` numerator
  spelling); partition witnesses: multiply the chart partitions of `A_i` by an
  `R`-level partition `Σ b_i g_i^{M} = 1` (span-⊤ powers; the
  `le_iSup_basicOpen_of_sum_eq_one` shape) — the classical quasi-compact patching;
  `eqn_rel` from the `A_i` clauses + immersion transport. This brick is where the
  500-line splits land (`Kit` = denominator-clearing + partition algebra +
  immersion-transport lemmas; `Glue` = the assembly).
- **Certificate locality**: the glued adaptation's apparatus localizes to the local
  apparatus: `colength`/`W(d)` are finite ⊕-indexed equalizers of section quotients;
  over `Away (g i)` they identify with the `A_i`-apparatus via the LANDED
  colength/overlap/glued base-change transports at `R → Away (g i)`
  (`DivisorFamilyPullbackCert/Glued` — they are stated for arbitrary `R'`).
  Then (c1)–(c4) + rank descend by Zariski-locality of module predicates. MATHLIB
  GIFTS TO AUDIT AT BUILD TIME (names from the v4.31 checkout, verify before use):
  `Module.Finite.of_localizationSpan`, `Module.FinitePresentation` localization
  lemmas, flatness `Module.Flat` localization descent (`RingTheory/LocalProperties/`,
  `RingTheory/Flat/Localization`), projectivity via
  `Module.Projective.of_finitePresentation_of_flat`-shaped composites (spec-dd-1 §3
  row (c1) route), `Module.rankAtStalk` under localization
  (`FreeLocus`-adjacent). If a gift is missing, the fallback is the
  finite-presentation + flat + rank route entirely through `FinitePresentation` local
  lemmas — negotiate in the stage commit, do not silently re-prove mathlib-shaped
  module theory (house rule; add to `Picard/FlatCokernel.lean`'s orbit only what is
  genuinely absent).

## 6. Stage S6 — general tests + packaging (`Picard/DivisorFamilyZariskiSheaf.lean`)

The `Pic0ZariskiSheaf` mirror on the S3 vehicle: `divFam.ext_of_le_cover`
(separation at arbitrary tests), `divFam.existsUnique_glue_of_le_cover` (gluing over
open covers of `T.left`), morphism-level functoriality of the vehicle (the `PicEtMap`
pattern — this is where spec-dd-1 §1e's deferred "functoriality along arbitrary test
morphisms" lands), and the `divFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u` packaging
+ sheaf statement in the form DDR-9 consumes (match `spec-dd-r.md` §3.8's homEquiv
shape; coordinate the exact functor spelling with the DD-R lane BEFORE freezing S6 —
inbox, not silent choice).

## 7. Stage order, sizes, delegation

`S1 [M, surgery — ONE commit, root build green before and after] → S2 [M] →
{S3 [M] ∥ S4 [M]} → S5 [L→XL, split Kit/Glue] → S6 [M→L]`. S4 does not need S3.
S5's Kit can start once S2 lands. Every stage: kernel discipline of the 07-14/14b/15
handoffs; keystones `lean_verify` axiom-clean `[propext, Classical.choice,
Quot.sound]`; `lake` under the mkdir-mutex; ledger commits private-index + CAS with
`show --stat HEAD` verification; root import edits from the HEAD blob + own lines
only (protocol §4); files ≤ 500 lines.

## 8. Vocabulary pins (I-0190 discipline — grep HEAD before coining)

`DivisorAdaptation.eqn_rel`, `DivisorAdaptation.ofAnchors`,
`DivisorAdaptation.eqn_ratio_isUnit`, `DivisorAdaptation.pullback`,
`DivisorAdaptation.isCertified_pullback`, `CertifiedDivisorFamily.mapAlg`,
`DivFam.mapAlg`, `DivFam.mapAlg_mk`, `DivFam.picClass_mapAlg`, `DivFam.mapAlg_id`,
`DivFam.mapAlg_comp`, `divFam`, `divFamAffineEquiv`, `divFam.map`,
`DivFam.eq_of_away_eq`, `DivFam.exists_glue_of_away_compat`,
`divFam.ext_of_le_cover`, `divFam.existsUnique_glue_of_le_cover`, `divFunctor`.

## 9. Risks

1. **⚠ The surgery touches the shared carrier file while two lanes are in flight.**
   Mitigated: anchor fields have exactly six consumer sites (all enumerated, §1d);
   DD-4's in-flight files consume none; the apparatus is untouched; `ofAnchors`
   restores the old construction signature. The S1 commit is atomic and verified by a
   full root `lake build` under the mutex. Inbox announcement precedes the commit.
2. **⚠ `DivisorFamilyFieldDegree` fix (§1d row 5)** is the least mechanical — the
   generic-point reading may prefer the piece's own presentation element; budget a
   real proof, not a rewrite.
3. **S5 partition/denominator algebra** is voluminous (the classical patching);
   split early, keep every window lemma named.
4. **Mathlib gift names (§5) unverified** — audit at build time; report absences in
   the stage commit and to the inbox.

*End of spec. Binding for the DD-2 stages; deviations require re-derivation from the
worksheet and a note in the stage commit message.*
