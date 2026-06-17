# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts-monoidalloc214

## Iteration
214

## Question
HIGH-STAKES adjudication. Resolve the conflict between Claim A (iter-213 prover + earlier
analogist: the residual needs a ~200–400 LOC stalk port; Mathlib supplies no monoidal
SheafOfModules/sheafification, "gated on the absent `MonoidalClosed`") and Claim B
(strategy-critic ts214: the abstract `Localization.Monoidal` API applies needing only
`[W.IsMonoidal]+[IsLocalization]`, no `MonoidalClosed`; the whisker field may be cover-based,
sidestepping the stalk port). Decide whether to fund the stalk build or instantiate the
abstract API.

## Verification status

Declarations marked **[V]** were independently confirmed against the project's pinned Mathlib
this session via `lean_loogle` / `lean_leansearch` + reading the project file. Declarations
marked **[V-213]** are carried from the iter-213 analysis `analogies/ts-monoidal213.md`, which
states it is fresh-LSP-verified; I did not independently re-confirm these this session (LSP
search was rate-limited), but they are internally consistent and load-bearing only for the
*sizing* of the port, not for the core adjudication.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Does the abstract `Localization.Monoidal` API apply to varying-ring modules, w/o `MonoidalClosed`? | PROCEED (Claim B correct on shape) | informational |
| 2. Is the residual whisker field provable on covers, flatness-free, w/o stalks? | NEEDS_MATHLIB_GAP_FILL (stalk port; flatness-free) | major |
| 3. Concrete path: fund stalk port, or instantiate abstract API? | **Fund the stalk port** | must-fix-this-iter |

**One-line adjudication:** Claim B is right that the API needs no `MonoidalClosed` and that the
residual is the `MorphismProperty.IsMonoidal.whiskerLeft` field and is flatness-free; Claim A is
right that this field genuinely reduces to a stalk argument (d.1+d.2), NOT a cover-level
injectivity proof. **Crucially, neither the abstract `Localization.Monoidal` instance nor
`MonoidalClosed` eliminates the residual — all three routes bottom out at the SAME obligation
`W.IsMonoidal` for the relative module tensor, whose proof is the stalk port. Fund the
~200–400 LOC (flatness-free) stalk port; it is the project's single remaining `sorry`
(`isLocallyInjective_whiskerLeft_of_W`, `TensorObjSubstrate.lean:411–419`).**

---

## Decision 1 — the abstract API applies, and needs NO `MonoidalClosed` (Claim B correct)

**[V]** `CategoryTheory.Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal`
(`Mathlib.CategoryTheory.Localization.Monoidal.Basic`). Exact signature (loogle-confirmed):
```
(L : C ⥤ D) (W : MorphismProperty C) [MonoidalCategory C] [W.IsMonoidal] [L.IsLocalization W]
  {unit : D} (ε : L.obj (𝟙_ C) ≅ unit) : MonoidalCategory (LocalizedMonoidal L W ε)
```
The hypothesis chain is **exactly** `[MonoidalCategory C] + [W.IsMonoidal] + [L.IsLocalization W]`.
**`MonoidalClosed` is NOT present.** Companion confirmed decls:
- **[V]** `CategoryTheory.MorphismProperty.IsMonoidal (W) [MonoidalCategory C] : Prop` — the
  two-field property.
- **[V]** `CategoryTheory.MorphismProperty.IsMonoidal.whiskerLeft :
  [W.IsMonoidal] (X) {Y₁ Y₂} (g) (hg : W g) → W (X ◁ g)` and `.whiskerRight` (+ the standalone
  lemmas `whiskerLeft_mem` / `whiskerRight_mem`).
- **[V]** `CategoryTheory.MorphismProperty.instIsMonoidalInverseImageOfMonoidalOfRespectsIso :
  [W.IsMonoidal] (F : C' ⥤ C) [F.Monoidal] [W.RespectsIso] → (W.inverseImage F).IsMonoidal`.
- **[V]** `PresheafOfModules.Monoidal.tensorObj` requires `R : Cᵒᵖ ⥤ CommRingCat` — i.e. the
  presheaf-level relative tensor over a presheaf of commutative rings that **already varies over
  the site**. So "varying ring" is covered at the presheaf level; the project's
  `X.presheaf : (Opens X)ᵒᵖ ⥤ CommRingCat` instantiates it directly.

**Reconciling Claim A's "gated on `MonoidalClosed`":** per iter-213 **[V-213]**, that gating is
real only for the *older* route `GrothendieckTopology.W.monoidal` (`Mathlib.CategoryTheory.Sites.
Monoidal`, under `variable [MonoidalClosed A] …`, whose `whiskerLeft` is built from
`MonoidalClosed.curry`). The earlier (iters 206–210) analysts found only that route. The
`Localization.Monoidal` API and the 2026 enough-points route (`Sites.Point.IsMonoidalW`
**[V-213]**) are `MonoidalClosed`-free. **So Claim B wins Decision 1: the API is the right
abstraction and `MonoidalClosed` is a red herring.** The fixed-base `Sheaf.monoidalCategory`
(`Sites.Monoidal`) covers only a **fixed** monoidal `A` with the *pointwise* tensor and does NOT
instantiate to `SheafOfModules R` with the *relative* tensor — so there is no off-the-shelf
monoidal `SheafOfModules`.

---

## Decision 2 — the residual IS the stalk port; flatness-free; NOT cover-only (both claims half-right)

The project's residual (`TensorObjSubstrate.lean:411`) is, modulo the `toPresheaf`/`inverseImage`
bookkeeping, **exactly the `whiskerLeft` field** of `MorphismProperty.IsMonoidal` for the
relative-module localizer:
```
isLocallyInjective_whiskerLeft_of_W (F) (g) (hg : J.W (toPresheaf g)) : IsLocallyInjective J (F ◁ g)   -- sorry, line 419
```
(`W_whiskerLeft_of_W` adds the free surjectivity half via `isLocallySurjective_whiskerLeft`,
which is closed by right-exactness.)

**Is it provable on covers, flatness-free, without stalks?** Split into the two sub-questions the
two claims disagree on:

1. **Flatness-free? YES (Claim B correct).** The prover's documented flatness wall
   (`ker(id_F ⊗ g_U)` not generated by `F ⊗ ker g_U` w/o Tor₁) only arises when preserving
   *injectivity in isolation*. But `g ∈ W` is locally **bijective**; stalkwise `(F ◁ g)_x =
   id_{F_x} ⊗ g_x` with `g_x` an **isomorphism**, and `id ⊗ (iso)` is an iso for ANY `F_x` — no
   flatness, because one inverts an iso rather than computing a kernel. This is precisely why the
   2026 `Sites.Point.IsMonoidalW` proof of `W.IsMonoidal` needs no `MonoidalClosed` and no
   flatness (`hP.W_iff` → stalkwise iso → `Functor.Monoidal.map_tensor` → `infer_instance`).
2. **Cover-based, sidestepping stalks? NO (Claim A correct).** The flatness-free proof routes
   through stalks. There is no cover/section-level proof of local *injectivity* of `id_F ⊗ g`
   that avoids both flatness and stalks — the combined bijectivity buys you the *stalk iso*, not a
   section-level injectivity argument. So Claim B's hope of "cover-based, sidestepping the stalk
   port" is over-optimistic.

**Does Mathlib already prove `W.IsMonoidal` for this localizer?** **No, for the relative module
tensor.** **[V-213]** `Sites.Point.IsMonoidalW` (`ObjectProperty.IsConservativeFamilyOfPoints.
isMonoidal_W`) gives `(J.W (A := A)).IsMonoidal` only for a **fixed** monoidal `A` with the
*pointwise* tensor on `Sheaf J A`. It does **not** transport to the relative `⊗_R` via
`instIsMonoidalInverseImageOfMonoidalOfRespectsIso`, because `toPresheaf : PresheafOfModules R ⥤
Presheaf Ab` is **not monoidal** (the relative tensor `⊗_R` is a quotient of `⊗_ℤ`, so `toPresheaf`
does not send `⊗_R` to the pointwise `⊗_Ab`). Hence the module-level `W.IsMonoidal` must be proved
directly = the stalk port. The two genuinely-absent ingredients (at the `PresheafOfModules` layer):
- **(d.1)** stalkwise-iso characterisation of the module-level `J.W` on `Opens X`. The general
  enough-points input exists: **[V-213]** `TopCat.hasEnoughPoints` (`Topology.Sheaves.Points`,
  2026) + the concrete iso bridge `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`
  (`Topology.Sheaves.Stalks`). Needs re-running for the module localizer; the
  `J.W ↔ IsIso(sheafify)` half is the file's own **[V]** `PresheafOfModules.
  inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` (already used, compiles, in the
  non-sorry `isIso_sheafification_map_of_W`).
- **(d.2)** stalk commutes with the relative module tensor: `(M ⊗ᵖ N)_x ≅ M_x ⊗_{R_x} N_x`
  (stalk = filtered colimit; `tensorLeft`/`tensorRight` preserve filtered colimits over a module
  category). Believed **absent** at the `PresheafOfModules` layer; this is the bulk of the LOC.

---

## Decision 3 — concrete path: FUND THE STALK PORT (do NOT instantiate the abstract API to "save" the associator)

**The decisive point that resolves the funding question:** instantiating
`instMonoidalCategoryLocalizedMonoidal` for `C = PresheafOfModules X.presheaf` (relative tensor),
`L = sheafification`, `W = J.W` **still requires `[W.IsMonoidal]`** — i.e. the identical
`whiskerLeft`/`whiskerRight` residual = the same stalk port. The abstract API gives the
*coherence* (associator/unitors/pentagon/triangle) for free, but:
- the project has **deliberately decided it does not need a `MonoidalCategory` instance at all**
  (`TensorObjSubstrate.lean:531–543`, §2 PIVOT: the relative Picard group law is on *iso-classes*,
  every axiom is a `Nonempty (… ≅ …)`; no coherence is ever consumed), and
- `tensorObj_assoc_iso` is **already closed** (full `by`-proof, `:659–702`) via the route-(d)
  three-step composite, resting on `W_whiskerLeft/Right_of_W` → the single `sorry`.

So instantiating the abstract monoidal instance would (i) buy coherence the project does not
consume, and (ii) cost the *same* `W.IsMonoidal` obligation. It is therefore **not** the path.
Claim B's "instantiate the API to kill the hand-assembled associator" does not apply here, because
the associator is already assembled and the residual is shared.

**Recommended next prover objective (unchanged single target):** close
`PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (`TensorObjSubstrate.lean:411–419`) by the
flatness-free stalk argument:
1. **(d.2)** prove `(M ⊗ᵖ N).stalk x ≅ M.stalk x ⊗_{R_x} N.stalk x` for the
   `PresheafOfModules.Monoidal.tensorObj` (filtered-colimit/tensor interchange). ~150–250 LOC; the
   genuinely new content. **[V]** the sectionwise computation already in the file
   (`toPresheaf_whiskerLeft_app_apply`, `tensorObj_obj`/`tensorObj_map_tmul`) is the base.
2. **(d.1)** module-level `J.W f ↔ stalkwise iso` on `Opens X`, from **[V-213]**
   `TopCat.hasEnoughPoints` + `isIso_iff_stalkFunctor_map_iso` + the file's **[V]**
   `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`. ~80–150 LOC, less if it transports
   from the underlying-`Ab` stalk criterion.
3. assemble (~20 LOC): `g ∈ W` →(d.1)→ `g_x` iso → `id_{F_x} ⊗ g_x` iso →(d.2)→ `(F ◁ g)_x` iso
   →(d.1)→ `F ◁ g ∈ W` ⟹ locally injective.

**Honest size: ~200–400 LOC, flatness-free, `MonoidalClosed`-free** — confirming Claim A's
magnitude with Claim B's corrections. Lower end is plausible because the hardest input
(enough points for `Opens X`) is already in Mathlib and the `J.W ↔ IsIso(sheafify)` half is
already in the project. **Watch item:** if (d.1)/(d.2) at the `PresheafOfModules` layer prove
heavier than budgeted, the iter-213 fallback (route (c): cover-level injectivity scoped to
`IsLocallyTrivial`, which the `OnProduct` consumers already carry) is the narrower retreat —
but it re-introduces a local-triviality hypothesis the route-(d) statement currently avoids.

---

## Must-fix-this-iter

- **Fund the stalk port, reject any pivot to instantiating `instMonoidalCategoryLocalizedMonoidal`
  / `MonoidalClosed` as a way around the residual.** All three routes share the obligation
  `W.IsMonoidal` for the relative module tensor; only the stalk argument discharges it
  (flatness-free). The single open `sorry`
  `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (`TensorObjSubstrate.lean:419`) IS the
  funded objective.

## Major

- The residual is genuine gap-fill (NEEDS_MATHLIB_GAP_FILL): Mathlib has no monoidal
  `SheafOfModules` for the relative tensor and no ready `W.IsMonoidal` for that localizer; (d.2)
  stalk-tensor interchange at the `PresheafOfModules` layer is the new analytic content.

## Informational

- Claim B's API findings are accurate and worth recording permanently: the localization-monoidal
  framework, its `MonoidalClosed`-free hypotheses, and `MorphismProperty.IsMonoidal` as the home
  of the residual. They explain *why* the project's route (d) is the Mathlib-aligned technique.
- The project's §2 decision to skip the full `MonoidalCategory` instance remains correct; do not
  reverse it to chase the abstract instance.

## Persistent file
- `analogies/ts-monoidalloc214.md` — adjudication + verified decl table captured for future iters.

Overall verdict: **Fund the ~200–400 LOC flatness-free stalk port (d.1+d.2) to close the single
residual `isLocallyInjective_whiskerLeft_of_W`; the abstract `Localization.Monoidal` API (no
`MonoidalClosed`, Claim B correct) does not bypass it because every route reduces to the same
`W.IsMonoidal` whisker field for the relative module tensor, which is the stalk argument
(Claim A correct on the port, wrong on flatness).**
