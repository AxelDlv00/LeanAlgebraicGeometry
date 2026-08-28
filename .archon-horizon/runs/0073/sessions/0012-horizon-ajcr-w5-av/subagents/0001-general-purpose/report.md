Survey complete. Report below.

## (A) T5 — `dim_k T_0(d.J) = g` in AJCR

The T5 spine is **landed and sorry-free**, with the numeral isolated as a named hypothesis. All of `Tangent/` and `AbelianVariety/` is sorry-free: 15 `sorry` grep hits across both trees, all docstring prose (verified with `grep -rnw`).

`Tangent/Pic0TangentSpace.lean` (the T5 file; variables at `:91-92`, `{k} [Field k] {C : Over (Spec (.of k))} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]`):

| decl | line | status |
|---|---|---|
| `JacobianData.identitySection` | :97 | proved; `GroupScheme.identitySection d.J` under `letI := d.grpObj` |
| `identitySection_isSection` | :103 | proved |
| `tangentSpaceCotangentDual` | :113 | proved. `pointedDualNumberPoints d.J d.identitySection ≃ Module.Dual (ResidueField (stalk …)) (CotangentSpace (stalk …))`. No rationality hypothesis — identity is a section |
| `tangentSpaceEquivPic0Kernel` | :138 | proved. `≃ {a : (pic0Functor C).obj (op (overDualNumber k)) // ((pic0Functor C).map (overDualNumberZero k).op).hom a = 1}`. Docstring flags: **bijection of sets, does not transport finrank** |
| `cotangentSpaceDual_equiv_pic0Kernel` | :147 | proved, the two composed |
| `finiteDimensional_cotangentSpace` | :159 | proved from `d.locallyOfFiniteType` → `IsLocallyNoetherian` |
| `finrank_eq_of_addEquiv_of_bijective_smul` | :209 | **proved, unconditional**. `(i : R → R') (j : M ≃+ M₁) (hi : Function.Bijective i) (hc : ∀ r m, j (r • m) = i r • j m) : finrank R M = finrank R' M₁`. `unfold Module.finrank; rw [rank_eq_of_equiv_equiv i j hi hc]` |
| `finrank_cotangentSpaceDual_eq_genus` | :229 | proved **from hypothesis** `hdim : finrank κ(e) (CotangentSpace …) = genus C`; body is `rw [Subspace.dual_finrank_eq]; exact hdim` |
| `nonempty_cotangentSpace_addEquiv_h1` | :254 | proved from the same `hdim` + `[Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]` |

**The real gate** is the `hdim` binder, and the file states precisely what it needs (:167-195): not the ε-kernel *bijection* but the **semilinear comparison** — a scalar bijection `κ(e) → k`, an additive equivalence to `H¹`, and the intertwining law, fed through `finrank_eq_of_addEquiv_of_bijective_smul`. Same residue AJC named `semilinearComparison_cotangentSpaceDual_h1Cok`.

Generic substrate in `Tangent/TangentCotangentCount.lean`: `Module.nonempty_addEquiv_of_finrank_eq_of_ringEquiv` (:69), `AlgebraicGeometry.nonempty_cotangentSpaceAddEquiv_of_finrank_eq` (:95), `DualNumber.instSubsingletonPrimeSpectrum` (:141), `pointedDualNumberPointsEquivOfOpenImmersion` (:167) — all proved. Note :136 records the open-immersion connector is **not** on AJCR's critical path (AJCR's `pic0Functor` is degree-zero by definition, not an identity component).

**Direct answers**: there is **no** AJCR declaration of shape "finrank of the k[ε]-kernel = genus" — the kernel appears only as a set bijection (`tangentSpaceEquivPic0Kernel`). There is **no** `SmoothOfRelativeDimension g` instance/theorem; only the named `Prop` abbrev (see B). The "dim = g" declarations are the two conditional ones at `Pic0TangentSpace.lean:229/:254`. Adjacent: `Cohomology/H1BaseFieldInvariance.lean:364` `finrank_h1_baseField_eq_genus : finrank K (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 1) = genus C` — proved, and it is the `K = k̄` uniformity T5/S1-a want. `genus` is defined at `Challenge.lean:89`.

## (B) S1 and S3 in AJCR

**S1 — `GeometricallyReduced d.J.hom`: nothing proved; it is an instance argument everywhere, and the worksheet retracts its own cheap route.**

- `Curve/GeometricallyReduced.lean` proves only the **converse**: `Smooth.geometricallyReduced` (:130), `SmoothOfRelativeDimension.geometricallyReduced` (:147), plus `Smooth.geometricallyIntegral` (:153). Using these for S1 is circular — S2 derives `Smooth` *from* `GeometricallyReduced`. `informal/w5-s-worksheet.md:108-116` records this as an explicit in-document retraction.
- No AJCR file contains `H^2`/`H²` for this argument, and no square-zero lifting brick for S1. `informal/w5-s-worksheet.md:66-72` explains why the H²=0 half is **free rather than proved**: `pic0Functor` goes through `picEt`, whose values are Čech classes on a **two**-chart cover (`Tangent/TruncExpCech.lean`, T2, landed) — a two-term complex has no degree-2 term at all, so the obstruction group is *absent by construction*, not computed to vanish. Confirms at `Cohomology/RigidEngineLatticeSixTerm.lean:17` ("two-term complexes have no `H²`").
- The expensive half is the ring-level bridge. Worksheet table at :78-83 prices the four links; link 2 (formally-smooth local algebra ⇒ regular) is **PARTIAL** in mathlib and link 4 (`IsReduced J_k̄ ⇒ GeometricallyReduced`) is **ABSENT**. Split into **S1-a** (stalk at identity reduced, gated on T3/T4, :95) and **S1-b** (translation spread via `AbelianVariety/Translation.lean`'s `isReduced_stalk_pointTranslationIso_iff`, :101).
- **S1-b0** is the mathlib-facing brick (:142): `IsReduced (X ×_k k̄) ⇒ GeometricallyReduced f`. Machine-probed at :147-156: the gap is **exactly the transcendental case** — mathlib's `Algebra.IsGeometricallyReduced` transport stops at algebraic extensions (`isGeometricallyReduced_field_iff`, instance at `RingTheory/Nilpotent/GeometricallyReduced.lean:71`), and `grep -rl IsGeometricallyReduced Mathlib/AlgebraicGeometry/` returns nothing — no bridge between the scheme class and the algebra class. Sized **[M/L]**, explicitly recommended **not** to start (:171). Option (b), a `smooth_of_grpObj` variant on the `k̄`-fibre, was probed and **does not dodge it** (:184-191): `smooth_of_grpObj_of_isAlgClosed` is `private` in mathlib, and even over `k̄` mathlib will not upgrade `IsReduced` to `GeometricallyReduced`.

**S3 — mathlib's exact signature** (`.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:134-138`):

```lean
@[mk_iff]
class SmoothOfRelativeDimension : Prop where
  exists_isStandardSmoothOfRelativeDimension : ∀ (x : X), ∃ (U : Y.Opens) (_ : IsAffineOpen U)
    (V : X.Opens) (_ : IsAffineOpen V) (_ : x ∈ V) (e : V ≤ f ⁻¹ᵁ U),
    IsStandardSmoothOfRelativeDimension n (f.appLE U V e).hom
```

One field, one constructor. To build it you supply, **for each point separately**, an affine chart pair plus a standard-smooth-of-rel-dim-`n` section map. It is pointwise and local-at-source — no chart coherence, no connectedness. There are no `of_*` constructors; what exists nearby is `SmoothOfRelativeDimension.smooth` (:143), `smoothOfRelativeDimension_isStableUnderBaseChange` (:166), the `IsOpenImmersion ⇒ rel-dim 0` instance (:177), `smoothOfRelativeDimension_comp` (:203, adds indices), and the `HasRingHomProperty … (Locally (IsStandardSmoothOfRelativeDimension n))` instance (:154). The pinning lemma for step 2 is `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` (`Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean:319`), requiring `[Nontrivial S] [IsStandardSmooth R S]`, and reading `↔ Module.rank S Ω[S⁄R] = n`.

Worksheet §3 (:234-280) freezes the S3 route on this: S2 gives a chart at each `x`; `iff_of_isStandardSmooth` pins its rel-dim by cotangent rank; X2 translation transports the count from the identity; T5 supplies `genus C` there. **No rel-dim descent brick needed** (R3 downgraded to [M], no mathlib-absent brick) because route (ii) hands the count at `k`. One recorded caveat at :273-280: translations by `k`-points may not reach every *scheme* point, in which case the contingency is to run steps 1-3 over `k̄` and pay the §5 codescent brick.

**S2, done** — `AbelianVariety/JacobianSmooth.lean:74`:
```lean
theorem smooth (d : JacobianData C) [GeometricallyReduced d.J.hom] : Smooth d.J.hom :=
  letI := d.locallyOfFiniteType
  letI : GrpObj (Over.mk d.J.hom) := d.grpObj
  smooth_of_grpObj d.J.hom
```
Note `smooth_of_grpObj` is mathlib's (`Mathlib/AlgebraicGeometry/Group/Smooth.lean:64`); the `Over.mk` ascription is the instance-keying step, machine-checked as η-defeq smoke test 1 at `Picard/JacobianData.lean:167`. Companion `smooth_of_smoothOfRelativeDimension` at :84.

**The `JacobianData` consumption interface** — `Picard/JacobianData.lean:87-100`, `Type (u+1)`, four fields:
- `J : Over (Spec (.of k))`
- `rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J`
- `locallyOfFiniteType : LocallyOfFiniteType J.hom`
- `quasiCompact : QuasiCompact J.hom`

Accessors: `grpObj` (:113, via `GrpObj.ofRepresentableBy`; not a global instance), `homEquiv` (:119, into `pic0Subgroup C T`), `homEquiv_comp` (:126), `uniqueUpToIso` (:134), `homEquiv_uniqueUpToIso_hom` (:139).

Assembly at `AbelianVariety/JacobianAbelianVariety.lean`: `isProper_and_smooth_of_abelSource` (:86), `isAbelianVariety_of_abelSource` (:100, delivering `IsSeparated ∧ IsProper ∧ Smooth ∧ GeometricallyIrreducible`), `smoothOfRelativeDimension_statement (d) : Prop := SmoothOfRelativeDimension (genus C) d.J.hom` (:117 — S3 as a named `Prop`, deliberately not a sorry), `isAbelianVariety_of_abelSource_of_relativeDimension` (:130). `AbelSourceData`'s five fields are at `AbelianVariety/AbelSource.lean:90-104` (`D`, `isProper`, `geometricallyIrreducible`, `abel`, `surjective`).

## (C) The AJC dimension bricks

The commit `d15916064` is **not resolvable** in this workspace's git (`.git` at the workspace root serves both trees; `cat-file -t` fails). Both files exist on disk and I read them at HEAD-on-disk.

**`Picard/EmbeddingDimensionBound.lean` — 0 `sorry`, and entirely project-generic.** Four declarations, none mentioning `Pic0`, `JacobianData`, or a curve:

- `ringKrullDim_le_finrank_cotangentSpace` (:98) — `(R) [CommRing R] [IsLocalRing R] [IsNoetherianRing R] : ringKrullDim R ≤ (finrank (ResidueField R) (CotangentSpace R) : WithBot ℕ∞)`. Two-line proof composing mathlib's `ringKrullDim_le_spanFinrank_maximalIdeal` (`Mathlib/RingTheory/Ideal/KrullsHeightTheorem.lean:489`) with `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace`. **No regularity, no residue-field condition.**
- `Scheme.ringKrullDim_stalk_le_finrank_cotangentSpace` (:110) — `(X) [IsLocallyNoetherian X] (z : X)`, one-line.
- `Scheme.topologicalKrullDim_le_of_forall_finrank_cotangentSpace_le` (:125) — `[IsLocallyNoetherian X] (d : ℕ) (h : ∀ z, finrank … ≤ d) : topologicalKrullDim X ≤ d`.
- `Scheme.topologicalKrullDim_eq_of_forall_finrank_cotangentSpace_le_of_regular` (:147) — adds `(z₀) (hreg : IsRegularLocalRing (stalk z₀)) (hz₀ : finrank … = d)`.

The asymmetry is mathematics, stated at :138-143: `≤` is unconditional; `≥` needs `z₀` regular, since a cusp has embedding dimension 2 and dimension 1.

**`Picard/Pic0Dimension.lean` — 0 `sorry`, but mixed portability.** Imports `Albanese/CodimOneExtension`, `Picard/SchemeKrullDimStalk`, `Picard/EmbeddingDimensionBound`, `Picard/Pic0AbelianVariety`.

- `Scheme.isRegularLocalRing_stalk_of_smooth_of_perfectField` (:90) — `{k} [Field k] [PerfectField k] (X : Over (Spec (.of k))) [Smooth X.hom] (z : X.left) : IsRegularLocalRing (stalk z)`. **Project-generic** (no `Pic0`), and a strict generalisation of the alg-closed `isRegularLocalRing_stalk_of_smooth`. `[PerfectField k]` is irremovable — it comes from `isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`.
- `Pic0.isLocallyNoetherian` (:142) — AJC-specific shape; docstring says its original binder was dead.
- `Pic0.genus_le_topologicalKrullDim_of_isRegular` (:180) — `(hreg : IsRegularLocalRing (stalk ((identitySection C).base default)))`. **Reports `sorryAx`** (measured, :153-155) because it consumes `finrank_cotangentSpace_eq_finrank_hModuleOne`.
- `Pic0.genus_le_topologicalKrullDim_of_smooth` (:201) — adds `[PerfectField k]` and `(hsm : Smooth (Pic0Scheme C).hom)`.
- `Pic0.topologicalKrullDim_eq_genus_of_forall_ringKrullDim_stalk_le` (:270) — carries `[PerfectField k]` + `hsm` + `hle` in `ringKrullDim` currency. Its docstring carries an explicit **RETRACTION** (:238-269) of the "the `≤` direction is genuinely absent" claim, and says USE INSTEAD the two below.
- `Pic0.topologicalKrullDim_le_genus_of_forall_finrank_cotangentSpace_le` (:313) — **axiom-clean**, arbitrary field, `hle` in cotangent currency.
- `Pic0.topologicalKrullDim_eq_genus_of_forall_finrank_cotangentSpace_le` (:353) — arbitrary field; `hle` (uniform cotangent bound) + `hreg` (at the identity only); reports `sorryAx` through front (a).

**`Picard/Pic0AbelianVariety.lean`**:
- `tangentSpaceCotangentDual` (:665) — **proved, sorry-free**. Returns a `Nonempty (Σ' e, (e ≫ hom = 𝟙) ×' (pointed dual-number points ≃ Module.Dual κ(e) (CotangentSpace …)))` bundle. Note the shape difference from AJCR's: AJC bundles the section existentially in a `Σ'`; AJCR's `identitySection` is a *definition* so `Tangent/Pic0TangentSpace.lean:113` returns a bare `≃`. AJCR's is the more usable face.
- `finrank_cotangentSpaceDual_eq_finrank_h1Cok` (:892) — **not directly sorried**, but its two-line body destructures `semilinearComparison_cotangentSpaceDual_h1Cok C S` (`:805`, body `sorry` at `:820`) and applies `finrank_eq_of_addEquiv_of_bijective_smul` (:703). So: **transitively sorried**, via the one open statement. It compares against a 2-affine-cover Čech cokernel `S.H1Cok`, not against `genus` directly; `finrank_cotangentSpace_eq_finrank_hModuleOne` (:929) does the last two hops. Also sorried in this file: `geometricallyReduced` (:1102) and a properness residue (:1340).

**What AJCR can re-derive cheaply vs. what is AJC-only:**

Cheap — `EmbeddingDimensionBound.lean` in full. It is pure mathlib + `SchemeKrullDimStalk`; every input is either mathlib or already present in AJCR. AJCR *has* the `SchemeKrullDimStalk` content: `Algebra/CoheightBridge.lean:149` `ringKrullDim_stalk_eq_coheight` is the same brick AJC's `Albanese/CoheightBridge.lean:152` supplies, and AJC's `SchemeKrullDimStalk.lean` imports only that plus `Mathlib`. AJCR has no file named `SchemeKrullDimStalk`, so the ~7 declarations of it (`topologicalKrullDim_eq_iSup_ringKrullDim_stalk` :81, `topologicalKrullDim_le_of_forall_ringKrullDim_stalk_le` :122, `ringKrullDim_stalk_le_topologicalKrullDim` :131, `topologicalKrullDim_eq_of_le_of_exists_ge` :142, `le_topologicalKrullDim_of_finrank_cotangentSpace` :172) would need porting first — but they are short and rest on the brick AJCR already has.

Also cheap — `isRegularLocalRing_stalk_of_smooth_of_perfectField`. AJCR has the exact upstream input at `Algebra/SmoothPrimeRegularity.lean:246` (same name) and the chart step at `Albanese/CodimOneStalkRegularity.lean:113` (`exists_isStandardSmooth_at_of_smooth`). AJCR's own `Albanese/CodimOneDVRStalk.lean:76` `isRegularLocalRing_stalk_of_smooth` is the *alg-closed, six-binder* version, so the perfect-field generalisation is a genuine gain and the proof at `Pic0Dimension.lean:96-122` should transplant with only the `Over (Spec (.of k))` convention already matching.

AJC-only — everything named `Pic0.*`. Those are typed against `Pic0Scheme C` with `[HasPicScheme C] [PicScheme.PicSchemeLocallyOfFiniteType C] [GeometricallyIntegral C.hom]`; AJCR's carrier is `d.J` for `(d : JacobianData C)` under `[GeometricallyIrreducible C.hom]`, with `pic0Functor` degree-zero by definition rather than an identity component carved out of `PicScheme`. Restating them at `d.J` is mechanical but is a restatement, not a port — and note AJC's `identitySection` (`Pic0AbelianVariety.lean:426`) is `GroupScheme.identityComponentSection (PicScheme C)`, which has no AJCR analogue by construction. The `hle` hypothesis (uniform cotangent bound at every point) is in both trees exactly the content of `SmoothOfRelativeDimension (genus C)` — i.e. AJCR's S3 — so the AJC dimension chain would consume AJCR's S3 rather than help produce it.

One correction worth flagging to the lane: `finrank_cotangentSpaceDual_eq_finrank_h1Cok` is often cited as "the sorried one". It is not sorried in its own body — it is a two-line consequence of `semilinearComparison_cotangentSpaceDual_h1Cok`, which is the single `sorry`. That matters because it is the same statement AJCR's `hdim` binder needs, and the AJCR file already carries the bridge lemma (`finrank_eq_of_addEquiv_of_bijective_smul`, `Pic0TangentSpace.lean:209`) that turns the semilinear comparison into the count — so both trees are blocked on one identical, transferable obligation, and whichever proves it hands it to the other.
