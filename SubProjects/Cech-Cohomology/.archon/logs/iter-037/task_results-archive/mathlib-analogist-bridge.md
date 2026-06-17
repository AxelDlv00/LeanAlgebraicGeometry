# Mathlib Analogist Report

## Mode
api-alignment

## Slug
bridge

## Iteration
037

## Question
Route B for 01I8 (`IsQuasicoherent F → IsIso F.fromTildeΓ` on `Spec R`) reduces to the keystone
`∀ f, IsLocalizedModule (powers f) ρ_f`, descended over a finite standard cover. The per-`gⱼ` step
transports `F` to `D(gⱼ) ≅ Spec R_{gⱼ}`, gives a global `Presentation`, and applies the DONE local
model. (1) section comparison, (2) presentation restriction, (3) quasicoherence locality /
`IsLocalizing`, (4) route validity / third-wall check.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 section comparison (`Γ` of transport ≅ `Γ` over open) | PROCEED | informational |
| Q2 presentation restriction | NEEDS_MATHLIB_GAP_FILL | informational |
| Q3 quasicoherence locality / `IsLocalizing` shortcut | NEEDS_MATHLIB_GAP_FILL | informational |
| Q4 route validity (third wall) | PROCEED (with flagged lane) | high-stakes |

## Answers to the four questions

**Q1 — section comparison: cheap / definitional.** `restrict_obj : Γ(M.restrict f, U) = Γ(M, f ''ᵁ U)`
is `rfl` (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:328`), and `restrict_map` (331) for the maps. The
linear comparison is the presheaf `.map`; compatibility with further restriction to `D(f)∩U` is
`map_comp`. No parallel API, no idiom mismatch. The project's local-model proofs already work in exactly
this style. **PROCEED.**

**Q2 — presentation restriction: the transporters exist; they ride on the Q4 bridge.** Mathlib has both
`Presentation.map (F) (η : F.obj (unit) ≅ unit)` for any colimit-preserving + unit-preserving functor
(`…/Sheaf/Quasicoherent.lean:179`) and `Presentation.ofIsIso` across an iso (132). The `over`-restriction
and the `pullback`/`restrict` functors all qualify (left adjoints — `Sheaf.lean:356`,
`PushforwardContinuous.lean:282`, `PullbackContinuous.lean:63`; unit-as-iso —
`PullbackFree.lean:105 [F.Final]`). Nested `over` is supported (`Quasicoherent.lean:353`). So restricting
`Presentation (F.over Uᵢ)` to `Presentation (F.over D(gⱼ))` and transporting across an iso are both free.
The catch: the SOURCE presentation lives in the `over` (localized-site) picture and the project's tilde
machinery needs an honest `(Spec R_{gⱼ}).Modules` presentation — see Q4. **NEEDS_MATHLIB_GAP_FILL.**

**Q3 — `IsLocalizing` does NOT exist.** The directive's conjecture (that the keystone is definitionally
`IsLocalizing F` and there is `isIso_fromTildeΓ_iff_isLocalizing`) is FALSE. The `IsQuasicoherent` section
of `Tilde.lean` runs 344–410 and ENDS at `isIso_fromTildeΓ_of_presentation` (398); there is no
`IsLocalizing`, no iff, and no `(F.restrict j).IsQuasicoherent` instance, and no
basic-open-cover-gives-global-presentation lemma. The keystone must be proved as the explicit chain.
**NEEDS_MATHLIB_GAP_FILL.**

**Q4 — route validity: there IS a third obligation, but it is bounded and has a Mathlib engine.**
The third obligation is **B3 = `restrict-over-compat`**: identify `F.over D(gⱼ)` (the localized-site object
`SheafOfModules ((Spec R).ringCatSheaf.over D(gⱼ))`, where `QuasicoherentData`'s presentation lives) with
`modulesRestrictBasicOpen gⱼ F` (an honest `(Spec R_{gⱼ}).Modules`, where `fromTildeΓ` lives), as an iso
carrying presentations.
- It is **NOT** `lemma-widetilde-pullback`. `modulesRestrictBasicOpenIso` relates iterated `restrict` to
  `pullback (specAwayToSpec f)` — both scheme-picture, never touching `over`. It does **not** discharge B3.
  B3 is genuinely distinct and currently unbuilt.
- It is **not a deep-math wall.** Mathlib's `pushforwardPushforwardEquivalence`
  (`PushforwardContinuous.lean ~305`) is the engine: instantiate it at the site equivalence
  `(Opens Spec R).over D(gⱼ) ≃ Opens(Spec R_{gⱼ})` (already inside Mathlib's open-immersion
  `opensFunctor` machinery, which `restrictFunctor` itself is built from) + structure-sheaf compatibility.
  Every primitive exists. Contrast Route P, whose walls ("localized sections for general qcoh", "tilde
  preserves finite limits") required genuinely new mathematics. **Route B converts two deep-math walls into
  one categorical-bookkeeping bridge.** **PROCEED**, with B3 as the single load-bearing lane.

## Build decomposition (ordered)
B0 [DONE] topology + pure-algebra + local-model + `modulesRestrictBasicOpen`/`Iso`. →
B1 [small] `QuasicoherentData F` → cover `Uᵢ` + `Presentation (F.over Uᵢ)`; refine to `D(gⱼ) ⊆ U_{φⱼ}`. →
B2 [medium] restrict the presentation `F.over U_{φⱼ} → F.over D(gⱼ)` via `Presentation.map`. →
**B3 [the obligation] `F.over D(gⱼ) ≅ modulesRestrictBasicOpen gⱼ F` via
`pushforwardPushforwardEquivalence` at the open-subscheme site equivalence.** →
B4 [small] `Presentation.ofIsIso` across B3 + `modulesRestrictBasicOpenIso`. →
B5/B6 [DONE consumers] `section_isLocalizedModule_of_presentation` + `isLocalizedModule_of_span_cover`;
section comparison `restrict_obj`-`rfl`.

## Informational
- The project's `modulesRestrictBasicOpen`/`modulesRestrictBasicOpenIso` are correct and reusable, but they
  build the scheme-picture HALF of the transport only. They do not connect to `over`, where the presentation
  originates. The unbuilt connection (B3) is the actual remaining work — planners must not read
  `modulesRestrictBasicOpenIso` as "the bridge is done".
- `QuasicoherentData.ofIsIso` (`Quasicoherent.lean:323`) shows Mathlib's own pattern for moving per-piece
  presentations across an iso — directly reusable in B4.
- `restrict_obj`/`restrict_map` being `rfl` means the eventual `IsLocalizedModule` of `ρ_f` reads the same
  presheaf the local model produces; no transport lemma needed for Q1/B6.

## Persistent file
- `analogies/bridge.md` — full citation table + decomposition + route-validity rationale for future iters.

Overall verdict: **PROCEED with Route B** — it is strictly better than Route P (two deep-math walls → one
categorical bridge with a Mathlib engine), the `IsLocalizing` shortcut does not exist so the keystone stays
an explicit chain, and the one genuine remaining obligation is **B3 (`restrict-over-compat`)** —
medium-size, bounded, distinct from `lemma-widetilde-pullback`, and NOT discharged by
`modulesRestrictBasicOpenIso`.
