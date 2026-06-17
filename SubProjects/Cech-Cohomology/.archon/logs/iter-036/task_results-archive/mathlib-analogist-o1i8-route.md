# Mathlib Analogist Report

## Mode
api-alignment

## Slug
o1i8-route

## Iteration
036

## Question
Given Mathlib's `tilde`/`Presentation`/`QuasicoherentData` machinery, what is the SHORTEST
Mathlib-aligned path to `[SheafOfModules.IsQuasicoherent F] → IsIso F.fromTildeΓ` on an affine
`Spec R`, and does it let the project DROP/SHORTCUT Route-P sub-steps (P1a affine-restriction,
P2 global-generation, P3 kernel-qcoh, `tildePreservesFiniteLimits`)? Three sub-questions:
(1) reduction shape — can Mathlib globalize local `QuasicoherentData` to a global `Presentation`
on an affine? (2) is `tildePreservesFiniteLimits` still needed and is its "no toSheaf" blocker
false? (3) is P1a (`F|_{D(f)} ≅ tilde(M_f)`) on the critical path or a detour?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Mathlib local `QuasicoherentData` → global `Presentation` on affine | NEEDS_MATHLIB_GAP_FILL | informational (gap is upstream) |
| 2. `tildePreservesFiniteLimits` needed? / "no toSheaf" blocker | DIVERGE_INTENTIONALLY (drop from critical path) | informational |
| 3. P1a framing (sheaf-iso/base-change vs `IsLocalizedModule`) | ALIGN_WITH_MATHLIB | critical (shipped code) |

## Direct answers to the three sub-questions

### (1) Reduction shape — NO Mathlib local→global on the affine; the gap is genuinely the project's.
`IsQuasicoherent F` is `Nonempty QuasicoherentData` — **local** data (a cover `X i` + a
`Presentation` of `M.over (X i)`, Quasicoherent.lean:201-208). The only Mathlib globalizing tool,
`QuasicoherentData.bind` (Quasicoherent.lean:360), merely **merges covers** (`I := Σ i, (D i).I`):
local data → local data, never local data → a *global* `Presentation`. There is **no**
`QuasicoherentData M → Presentation M` and **no** qcoh-closed-under-kernels / abelian-subcategory
lemma anywhere under `Mathlib/Algebra/Category/ModuleCat/Sheaf/` (grep for
`IsQuasicoherent.*(kernel|abelian|exact|closed)` is empty). `Presentation.isQuasicoherent`
(Quasicoherent.lean:317) only goes the easy direction (global presentation → local qcoh).
Conclusion: producing a global `Presentation` from `IsQuasicoherent F` on `Spec R` **is** Stacks
01I8 / Hartshorne II.5.5, and its hard analytic core is **01HV localization-of-sections**
(`Γ(D(f),F)=Γ(X,F)_f`, references/stacks-schemes.md:37), which Mathlib does not have for abstract
qcoh `F`. The project must build it; no Mathlib path shortcuts it.

### (2) `tildePreservesFiniteLimits` — the "no toSheaf" blocker IS false, but the lemma is OFF the shortest path.
The blocker claim is wrong on its own terms: `SheafOfModules.toSheaf R` exists and **reflects
isomorphisms** (`ModuleCat/Presheaf/Sheafification.lean:41`), preserves finite limits
(`ModuleCat/Sheaf/Limits.lean:118`), hence is `ReflectsFiniteLimits`
(`Limits/Preserves/Finite.lean:175`, `reflectsFiniteLimits_of_reflectsIsomorphisms`). The precise
chain that discharges the categorical reduction is:

```
reflectsFiniteLimits_of_reflectsIsomorphisms : ReflectsFiniteLimits (toSheaf R)
preservesFiniteLimits_of_reflects_of_preserves (tilde.functor R) (toSheaf R)   -- Finite.lean:163
  ⟸ PreservesFiniteLimits (tilde.functor R ⋙ toSheaf R)        -- the only remaining obligation
```

So `tildePreservesFiniteLimits` reduces to **`tilde.functor R ⋙ toSheaf R` preserving finite
limits** — tilde-as-a-TopCat-sheaf preserves kernels — which is the stalk-wise flatness of
localization (stalk of `tilde M` at `x` is `M_{p_x}`, Tilde.lean:131; the project already has this as
`stalkMapₗ_eq`/`tilde_stalkFunctor_map_toStalk` in TildeExactness). This `toSheaf` route is *cleaner*
than the project's hand-rolled `tildePreservesFiniteLimits_of_toPresheaf` (which went through
PresheafOfModules objectwise, where `Γ(U,tilde M)` for general `U` is not a localization). Net: the
build is ~1 stalk lemma from done.

**However**, the global-`Presentation` reduction does **not** require it.
`isIso_fromTildeΓ_of_presentation` (Tilde.lean:398) builds the iso from `tilde` preserving
*colimits* (left adjoint) — no finite-limit/kernel preservation of `tilde` appears.
`tildePreservesFiniteLimits` is needed only by Route-A step P3 (kernel `σ.π` quasicoherent), and even
there it does **not** cleanly settle kernel-qcoh for an abstract `F` (that needs
qcoh-closed-under-kernels, which Mathlib lacks). So: keep the done stalk lemmas as dormant assets,
but do not spend iters finishing `tildePreservesFiniteLimits` — Route B needs none of it.

### (3) P1a is on the critical path **as content** but MIS-FRAMED — reframe it (drops the base-change wall).
The localization-of-sections that P1a encodes is the keystone of *every* route, so its content is not
droppable. But the shipped framing `F|_{D(f)} ≅ tilde(M_f)` (via `Scheme.Modules.restrict` +
`basicOpenIsoSpecAway` + presentation transport) is strictly heavier than needed and hits the
absent-Mathlib **tilde base-change** wall at L2 `tilde_restrict_basicOpen`. Mathlib states the entire
local `tilde` theory in `IsLocalizedModule` language and `fromTildeΓ`'s `D(f)`-component is *literally*
`IsLocalizedModule.lift (.powers f) (toOpen …) (Γ(X,F) → Γ(D(f),F))` (Tilde.lean:200-203). So the
component is iso ⟺ the section-restriction map `Γ(X,F) → Γ(D(f),F)` is `IsLocalizedModule (.powers f)`
— a statement that (a) needs no base change, (b) descends over a finite `D(g_i)` cover via the project's
already-built `isLocalizedModule_of_span_cover` (P1b), and (c) matches STRATEGY's own P1 phrasing
(`Γ(D(f),F)=Γ(X,F)_f via IsLocalizedModule.mk`). Reframing P1a to this is the alignment fix.

## Shortest Mathlib-aligned route (Route B)
1. For qcoh `F`, prove `IsLocalizedModule (.powers f) (sectionRestriction : Γ(X,F) → Γ(D(f),F))` by
   `isLocalizedModule_of_span_cover` over a finite `D(g_i)` cover on which the given
   `QuasicoherentData` presentations make `F|_{D(g_i)}` a concrete cokernel of frees (tilde-of-a-module
   by `presentationTilde`), where section-localization of the free pieces is the structure-sheaf
   localization and transfers through the cokernel + the project's existing standard-cover Čech
   exactness (`CechAcyclic.sectionCech_affine_vanishing`). No base change.
2. `forget`/`toSheaf` reflects isos ⟹ check `F.fromTildeΓ` on the basis `{D(f)}` (or on stalks via
   `isIso_iff_stalkFunctor_map_iso`, Stalks.lean:652).
3. Each `D(f)`-component is `IsLocalizedModule.lift` of the map in step 1, hence iso ⟹ `IsIso
   F.fromTildeΓ`, the 01I8 instance; the conditional `qcoh_iso_tilde_sections` upgrades unconditionally.

This drops, from the critical path: P1a's base-change L2, `tildePreservesFiniteLimits`, P2
global-generation, P3 kernel-qcoh. Route A (`isIso_fromTildeΓ_of_genSections`, already axiom-clean)
stays a correct but strictly-longer fallback that additionally needs the Mathlib-unsupported
kernel-qcoh fact.

## Must-fix-this-iter
- **Decision 3 (P1a reframing).** `QcohRestrictBasicOpen.lean`'s shipped `modulesRestrictBasicOpen`/
  `…Iso` + the planned L2 `tilde_restrict_basicOpen` commit the project to a sheaf-iso/base-change
  packaging that requires a tilde base-change lemma absent from Mathlib. Redirect P1a to
  `IsLocalizedModule (.powers f) (Γ(X,F) → Γ(D(f),F))` (Mathlib's `IsLocalizedModule` idiom, the form
  `fromTildeΓ`-on-basic-opens consumes and `isLocalizedModule_of_span_cover` discharges). Cost of not
  aligning: a multi-hundred-LOC base-change build (`lemma-widetilde-pullback`) with no Mathlib support,
  for a result the lighter form makes unnecessary.

## Informational
- **Decision 1** (NEEDS_MATHLIB_GAP_FILL): the local→global step is genuinely the project's; no
  Mathlib globalizer exists. The genSections/presentation wrappers are correct but their missing input
  (global generation) is itself downstream of the same 01HV core Route B uses directly.
- **Decision 2** (DIVERGE_INTENTIONALLY): `tildePreservesFiniteLimits` is completable (the "no toSheaf"
  justification is false; the `toSheaf` chain above works, ~1 stalk lemma remaining) but is not on the
  shortest path — drop it. Keep `stalkMapₗ`/`stalkMapₗ_eq` as dormant assets.

## Persistent file
- `analogies/o1i8-route.md` — route comparison + the three decisions captured for future iters.

Overall verdict: take Route B — reframe P1a to the `IsLocalizedModule` section-restriction form
(`isLocalizedModule_of_span_cover` discharges it) and feed `fromTildeΓ`-iso-on-`{D(f)}`; this is the
shortest Mathlib-aligned path and drops P1a-base-change, `tildePreservesFiniteLimits`, P2 and P3 from
the critical path, with the genSections presentation route kept as a longer fallback.
