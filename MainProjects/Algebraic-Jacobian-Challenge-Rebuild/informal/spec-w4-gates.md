# SPEC W4-GATES — the three bricks between the landed tree and `divRepAff` (2026-07-18, Fable design lane)

*Parent: `informal/spec-dd-r.md` (+ Addendum 1) and `informal/spec-dd-2.md` (Addendum 2).
Recon of record this pass (all file:line verified by direct read): `DivFam.mapAlg` is
LANDED (`Picard/DivisorFamilyMapAlg.lean:275`, with `CertifiedDivisorFamily.mapAlg:266`,
`mapAlg_id:316`, `mapAlg_comp:349`, `picClass_mapAlg:288`) — spec-dd-r §0's "mapAlg not
landed" is stale. `DivFamZar.mapAlg` is TOTAL (`Picard/DivisorFamilyZarMapAlg.lean:175`)
with `eq_of_away_eq:240`. DDR-6/7 (`Picard/DivSchemeClassify.lean`) and DDR-8
(`Picard/DivSchemeMono.lean`) are on disk from the 07-18 ~02:20-killed lane, zero
sorries, under faithful re-verification this session. DD-2 S6b spelling (A) of I-0222
is CO-SIGNED by the DD-R lane (this session): `divFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤
Type u` on `divFamZar` values — `Picard/DivisorFamilyZarFunctor.lean` staged.*

After the salvage lands, exactly three bricks separate the tree from `divRepAff`
(DDR-9, affine form). Each is self-contained, launchable in parallel in principle,
**but machine memory forces one heavy elaboration at a time** (a single worker on
`DivSchemeClassify.lean` peaked at 58 GB on 07-18 and had to be killed; the 02:20 lane
death was almost certainly the same OOM. Single-file `lake build <module>` with
`LEAN_NUM_THREADS=1` is the mandated check for heavy files this session.)

## G-1. `hfib` — the fibrewise h¹-data of a certified adaptation (unlocks `hsurj` everywhere)

**Statement (pin).** For `A : DivisorAdaptation …` over Noetherian `R`,
`hc : A.IsCertified g`, and `a ∈ {windowM_choice π hπ g, windowM_choice + windowS_choice}`:

```
theorem isCertified_fibrewise_h1 …
    (hc : A.IsCertified g) (p : PrimeSpectrum R) :
    Subsingleton ((datumPair (A.thetaIdealDatum a)).H1 ⊗[R] p.asIdeal.ResidueField)
```

This is the `hfib` slot consumed verbatim by `thetaGluedEval_surjective`
(`Picard/DivisorThetaSurjectivity.lean:487`), `subsingleton_hModule_thetaIdealDatum_one`
/ `finite_vanishingSubmodule` / `projective_vanishingSubmodule`
(`Picard/DivSchemeCertificateEngine.lean:306,318,330`), `finite_thetaGlued` (`:406`).
Discharging it makes `hsurj` derivable wherever a certificate is standing, collapsing
the threaded `hsurj` in `RiemannRoch/CarveDegree.lean:112,183,227` and all six mono
lemmas of `Picard/DivisorFamilyEpsMono.lean`.

**Route (no circle).** Do NOT route through the DDR-2 pinch (it consumes `hsurj`; that
way lies the Task-4(a) circle). Instead:
1. The H¹ fibre `(datumPair …).H1 ⊗ κ(p)` compares to the H¹ of the fibre datum over
   `κ(p)` — the RigidEngine4 base-change kit (`Cohomology/RigidEngine4BaseChange.lean`)
   is the landed comparison home; the datum's two-cover Čech H¹ base-changes on the
   nose there (right-exactness of Čech H¹ under base change, no flatness needed for
   the SURJECTION direction H¹ ⊗ κ(p) ↠ H¹(fibre): a Čech complex of a two-cover is a
   two-term complex, H¹ is a cokernel, cokernels commute with ⊗).
2. At the fibre: `H¹(C_κ(p), 𝒪(Θᵃ − d_p)) = 0` by the DD-0 ledger normalization
   (`window_normalization` / N-pack transport at `κ(p)` —
   `RiemannRoch/DegreeBaseFieldInvariance.lean` + the 5b95cba0c N-pack are the landed
   base-field window transport), licensed at `deg d_p ≤ 2g` by
   `two_mul_genus_le_M_mul_windowδ`.
3. `deg d_p = g` (hence `≤ 2g`) comes from the CERTIFICATE, not the pinch: the fibre
   degree of the cut divisor is the total colength of the pulled-back adaptation
   (SB-3 chart colength dictionary; `IsCertified.finrank_glued`
   (`Picard/DivisorFamilyField.lean:152`) at `κ(p)` after `isCertified_pullback`
   (`Picard/DivisorFamilyMapAlg.lean:245`)). Pull the family to `κ(p)` with
   `CertifiedDivisorFamily.mapAlg`, apply the field-level dictionary.
Size M→L. New file `Picard/DivisorThetaFibreData.lean` (or extend
`Picard/DivisorThetaFibre.lean` if < 500 L total). Keystone name pin:
`DivisorAdaptation.IsCertified.fibrewise_h1` + corollary
`DivisorAdaptation.IsCertified.thetaGluedEval_surjective` (composing
`Picard/DivisorThetaSurjectivity.lean:487`).

## G-2. ε-naturality (DD-4 Task 7) — the base-change square of the window pair

**Statement (pin).** Along `φ`-free instance form (`[Algebra R R'] [IsScalarTower k R R']`,
matching `DivFam.mapAlg`):

```
theorem divFamEps_mapAlg (F : DivFam C R π g) :
    divFamEps hπ g (DivFam.mapAlg R' g F)
      = (windowBaseChange R' (divFamEps hπ g F).1, windowBaseChange R' (divFamEps hπ g F).2)
```

where `windowBaseChange R' : Submodule R (R ⊗[k] H_a) → Submodule R' (R' ⊗[k] H_a)` is
the pinned pushforward `Submodule.map (windowBaseChangeMap …)` along the `k`-anchored
ambient comparison `R ⊗[k] H_a →ₗ[R] (restrict-scalars of) R' ⊗[k] H_a`
(`AlgebraTensorModule.cancelBaseChange` orientation; ONE recorded seam, spec-dd-3 §0
discipline — coin `windowBaseChangeMap` once, reuse everywhere; check
`Picard/DivisorFamilyPullback.lean:129` `relTermBaseChangeAlg` and its neighbours first:
the piece-level comparison maps are landed there and the ambient one may already exist
under another name).

**Route.** `divisorWindow = Submodule.comap (relThetaWindowEquiv) (vanishingSubmodule)`
(`Picard/DivisorFamilyWindow.lean:103`). Two halves:
1. **⊇ (formal half):** `windowBaseChange` of the window lands in the window of the
   pulled-back family — equations pull back to equations
   (`DivisorAdaptation.pullback`'s own construction, `DivisorFamilyMapAlg.lean:175`,
   base-changes the pieces via the DivisorFamilyPullback plumbing; germ-membership of a
   base-changed vanishing section is `vanishingSubmodule` chasing).
2. **⊆ (the certificate half):** both sides are finite projective over the respective
   rings with the SAME corank `g` in their ambients once G-1 stands
   (`projective_divisorWindow`, `finite_divisorWindow`,
   `Picard/DivSchemeCertificateEngine.lean:373,387`, now with `hfib` from G-1;
   corank from `IsCertified.finrank_glued` / the windowQuotEquiv corank kit in
   `RiemannRoch/CarveDegree.lean`). A containment of finite projective submodules with
   equal finite corank in a projective ambient, whose quotients are both projective, is
   an equality by `rankAtStalk` arithmetic — the DDR-5 rank-argument precedent
   (`Picard/DivSchemeEps.lean:160` region has the surjection-of-equal-rank kit; reuse
   its lemmas, do not recoin).
   Fallback if rank arithmetic fights: the split-kernel route — the certified window is
   the kernel of the (engine-split) map to the ambient projective quotient
   (DDR-4 (c3)/(c4) discharge in `Picard/DivSchemeCertificate.lean`), and kernels of
   split maps of projectives base-change on the nose.
Size M→L. New file `Picard/DivisorFamilyEpsNaturality.lean`. Keystone pins:
`divFamEps_mapAlg`, plus the localization corollary at basic opens
`divFamEps_mapAlg_awayMap` (the DDR-9 gluing consumer shape).
G-1 is a soft gate of the ⊆ half; the file may thread `hfib` per-window meanwhile
(named, exactly the engine slot) so G-2 need not WAIT on G-1.

## G-3. Φ — the field window→functionField dictionary (I-0214's open boundary)

**Statement (pin).** Over a field `K` (test), for the embedding window `N := M•F` with
`hH1`: an injective `K`-linear
`Φ : (K ⊗[k] H_M) →ₗ[K] (relCurve C K).functionField` with
`Submodule.map Φ (divFamEps hπ g F).1 = divisorSections K (N' − divFamDivisor F) ⊤`
in exactly the threaded shape of `Picard/DivisorFamilyEpsMono.lean:229-234` (six
occurrences; `N'` the abstract-N of I-0204).

**Route.** `K ⊗[k] H_M ≃ₗ H⁰(C_K, Θᴹ)` is `relThetaWindowEquiv` (landed). The missing
leg is the twist trivialization at the generic point: `H⁰(Θᴹ) ↪ K(C)` sending a section
to its ratio against a fixed meromorphic trivialization of `Θᴹ` — the meromorphic
bridge substrate (`AJCR.picard.degree.bridge`, divisorClass surjectivity kit) and
`divisorSectionsEquivH0` (`RiemannRoch/SectionSpaces.lean:349`) are the landed homes;
the generic-point germ injection for an irreducible reduced curve is the
`functionField` API. Image identification = the sections dictionary at the divisor
level: a section of `Θᴹ` vanishing along `d` reads as a rational function with divisor
`≥ d − Θᴹ`, i.e. `divisorSections K (N' − D)` — `mem_divisorWindow_iff`
(`DivisorFamilyWindow.lean:111`) + `coeffAt_eq_toAdd_ordZ_eqn`
(`Picard/DivisorFamilyFieldDegree.lean:161`) + the `DivisorStalkIdeal` pole-bound kit.
Size M. Field-level only — no relative subtleties. New file
`Picard/DivisorFamilyFieldDictionary.lean`. Keystone pins: `divFamPhi`,
`divFamPhi_injective`, `map_divFamPhi_eps_fst`.

## Consumption map (why these three)

- G-1 ⟹ `hsurj` collapses everywhere a certificate stands (pinch, mono lemmas, Gr
  membership `divisorWindowGr` (`DivisorFamilyWindow.lean:194`), engine transport).
- G-1 + G-3 ⟹ `hbridge` of `divFam_divEq_of_eps_eq` (`Picard/DivSchemeMono.lean:193`)
  discharges: fibrewise field mono (landed, I-0214) instantiated at `κ(p)` through
  `CertifiedDivisorFamily.mapAlg` + colon-Tor upgrade (landed pair) — DDR-8 goes
  unconditional.
- G-2 ⟹ DDR-9 backward gluing (overlap agreement via hom-ext on base-changed frames)
  + Law 1 (ε of a pulled-back universal family = pulled-back tautological pair, with
  DDR-5) + the frame-locus production over a basic-open cover.
- All three + salvage + S6b ⟹ `divRepAff` (spec-dd-r §3 item 8 at affine tests,
  Addendum-1 form) assembles with NO threaded seams; DD-2's
  `ext_of_le_cover`/`existsUnique_glue_of_le_cover` then lift it to the full `divRep`.

## Discipline

spec-dd-r §Discipline verbatim (window facts through ledger names; no
support-separation hypotheses; private-index+CAS commits; keystone `lean_verify` with
axioms exactly `[propext, Classical.choice, Quot.sound]`; files ≤ 500 L; root-import
edits HEAD-blob + own line). Memory discipline this session: ONE heavy lane at a time;
`LEAN_NUM_THREADS=1` builds; check `free -g` before opening a second worker; the lake
mutex is the mkdir directory protocol of `informal/protocol-concurrent-lanes.md` §2.
