All three priority items were verified before this check-in. Report follows; nothing is left mid-flight except one axiom probe noted at the end.

## Caveat first: the file moved under me

`Picard/FGAPicRepresentability.lean` was rewritten by another lane during this recon (mtime 18:47:44, 958 → 1001 lines, olean deleted then rebuilt 18:51). Every line number below is re-verified against the current on-disk state (md5 `8575d240ccf42568b5227c6f6f21e636`), and every probe was re-run after the rebuild. The caller's cited `:263` is now **:265**; `~503` is now **:533**.

## 1. `HasPicScheme`: no instance, synthesis fails — confirmed by probe

**Zero `instance` producers project-wide.** The only producer is `theorem picSchemeOfHasRationalPoint` at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:533` (conclusion `HasPicScheme C := by` at :537) — a `theorem`, and it additionally demands `[HasRationalPoint C]`. Class declared at :265; its docstring states the omission is deliberate.

Verified with `/tmp/ajc_p2_probe1.lean` and `/tmp/ajc_p2_probe2.lean`, re-run post-rebuild. Exact error, identical in all three configurations:

```
error(lean.synthInstanceFailed): failed to synthesize instance of type class
  HasPicScheme C
```

Configurations tried: (a) bare `[SmoothOfRelativeDimension 1] [IsProper] [GeometricallyIntegral]`; (b) the same **plus `[HasRationalPoint C]`**; (c) the same plus `[IsAlgClosed k]`. All fail. The étale control `inferInstance : HasPicSchemeEt C` succeeds in the same file, so the probe is not a stale-import artifact.

Consequence confirmed: **74 declarations** take `[HasPicScheme _]` and none is reachable by synthesis — `Pic0AbelianVariety.lean` 34, `IdentityComponent.lean` 14, `FGAPicRepresentability.lean` 9, `Pic0Dimension.lean` 6, `GroupSchemeHomogeneity.lean` 5, `Jacobian.lean` 4, `HomogeneityOrbitCollapse.lean` 2. A caller must name `picSchemeOfHasRationalPoint`, as `Jacobian.lean:635` does via `haveI`.

## 2. Étale route reaches the headline; the legacy interface is stranded

`instHasPicSchemeEt` (:396) is unconditional, body `⟨(fgaPicardRepresentability C).1⟩`. The étale interface has **21 consumers in exactly two files**: `FGAPicRepresentability.lean` (`HasPicSchemeEt` :385, `instHasPicSchemeEt` :396, `PicSchemeEt` :409, `representableEt` :422, `instPicSchemeEtLocallyOfFiniteType` :431, `instPicSchemeEtIsSeparated` :440, `groupSchemeStructureEt` :473) and `Picard/Pic0Et.lean` (`Pic0SchemeEt` :81, then `grpObj` :100, `geometricallyIrreducible` :113, `locallyOfFiniteType` :123, `smooth_of_geometricallyReduced` :150, `geometricallyReduced` :170, `smooth` :179, `isSeparated` :201, `universallyClosed` :223, `proper` :232).

Answering the split directly: **`IdentityComponent.lean` and `Pic0AbelianVariety.lean` contain zero occurrences of `SchemeEt` / `Pic0Et` / `representableEt` / `picEt`** — both are wholly legacy `picSharp`. `Pic0Et.lean` is wholly étale. `Jacobian.lean` (33 `Pic0SchemeEt`/`Pic0Et.` references) is the only meeting point.

So the étale route reaches `Pic0Et.lean` → `Jacobian.lean` headline and stops. It does not touch `Pic0Dimension.lean`, `GroupSchemeHomogeneity.lean`, `HomogeneityOrbitCollapse.lean`, `IdentityComponent.lean`, `Pic0AbelianVariety.lean`, or `Albanese/AlbaneseUP.lean` — those 61 declarations sit behind the dead gate.

## 3. Headline is sorry-reachable at depth 1

`AlgebraicJacobian/Challenge.lean` **does not exist in AJC** — the only workspace `Challenge.lean` is in the sibling `Algebraic-Jacobian-Challenge-Rebuild`. AJC's headline is `Jacobian.lean` + `AbelJacobi.lean`.

`picardJacobianWitness` (`Jacobian.lean:685`) has exactly the three challenge hypotheses `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` — no rational point, no `HasPicScheme` — and no local `sorry`. But `#print axioms` (`/tmp/ajc_p2_probe3.lean`, re-run post-rebuild) reports **`sorryAx`** for `picardJacobianWitness`, `nonempty_jacobianWitness`, `jacobianWitness`, `Jacobian`, and all four instances (`instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`).

Shortest chains, per witness field:

- `smoothGenus` → `smoothOfRelativeDimension_genus_pic0Et` (:424, sorry :427) — **depth 1**
- `isAlbaneseFor` → `isAlbanese_pic0Et` (:541, sorry :548) — **depth 1**
- `smooth` → `Pic0Et.smooth` (:179) → `Pic0Et.geometricallyReduced` (:170, sorry :175) — depth 2
- `proper` → `Pic0Et.proper` (:232) → `Pic0Et.universallyClosed` (:223, sorry :228) — depth 2
- `J` / `grpObj` / `geomIrred`: the four `Pic0Et` carriers measure axiom-clean `[propext, Classical.choice, Quot.sound]`, but `Pic0SchemeEt` needs `[HasPicSchemeEt C]`, whose sole instance (:396) carries `sorryAx` from `fgaPicardRepresentability` (:369, sorry :377) — depth 2 through the gate

Five distinct obligations, matching the header at `Jacobian.lean:47-56`. Verified genuinely clean (so not obligations): `Pic0Et.smooth_of_geometricallyReduced`, `Pic0.smooth_of_geometricallyReduced`, `Pic0.universallyClosed_of_valuativeCriterion`, `Pic0.proper_of_valuativeCriterion`.

## 4. Sorry census: the 12 and 24 are docstring-inflated

**`Jacobian.lean` has 4 code sorries, not 12** (8 of the 12 grep hits are prose at :130, 366, 443, 459, 479, 585, 586, 676): `smoothOfRelativeDimension_genus_pic0` @390 sorry :394 (`SmoothOfRelativeDimension (genus C) (Pic0Scheme C).hom`, gated); `smoothOfRelativeDimension_genus_pic0Et` @424 sorry :427 (same for `Pic0SchemeEt`, ungated); `isAlbanese_pic0` @511 sorry :519 (`@IsAlbanese … (Pic0Scheme C) …`, gated); `isAlbanese_pic0Et` @541 sorry :548 (same for `Pic0SchemeEt`, ungated).

**`Pic0AbelianVariety.lean` has 3 code sorries, not 24** (25 grep hits, 22 prose; the file's own header at :50-51 says "three"): `semilinearComparison_cotangentSpaceDual_h1Cok` @838 sorry :853 (existence of bijective `i : ResidueField(stalk) → k` and `j : Dual(CotangentSpace) ≃+ S.H1Cok (toModuleKSheaf C)` with `j (r • x) = i r • j x`); `geometricallyReduced` @1129 sorry :1135; `universallyClosed` @1367 sorry :1373. All three carry `[HasPicScheme C] [PicSchemeLocallyOfFiniteType C]`, so none feeds the headline.

Also: `IdentityComponent.lean` 2 (`finrank_eq_genus` :1916, `kPoints_iff_kerDegree` :1963, both gated); `Pic0Et.lean` 2 (:175, :228); `FGAPicRepresentability.lean` 1 (:377); `AbelJacobi.lean` 0.

## Target-selection consequence

Only five statements can move the headline: `fgaPicardRepresentability` (:377), `Pic0Et.geometricallyReduced` (:175), `Pic0Et.universallyClosed` (:228), `smoothOfRelativeDimension_genus_pic0Et` (Jacobian :427), `isAlbanese_pic0Et` (Jacobian :548). The two depth-1 leaves are the cheapest structural wins. Note `Pic0AbelianVariety.geometricallyReduced` (:1135) and `Pic0Et.geometricallyReduced` (:175) are the same mathematics on two carriers — only the latter is load-bearing, so a lane that proves the former buys nothing measurable without a separate `picSharp → picEt` transport.

**Unverified:** the axiom measurement for `AbelJacobi.Jacobian.ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp` — its olean was deleted by the concurrent build and I did not take the build lock. They project from `jacobianWitness`, so `sorryAx` follows by inheritance, but I did not measure it directly.
