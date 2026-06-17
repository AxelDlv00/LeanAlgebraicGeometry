# Session 48 (iter-048) — review

## Metadata
- **Sorry count:** 2 → 2 (no regression). Both frozen/superseded:
  `CechHigherDirectImage.lean:679` (protected P5b main theorem), `CechAcyclic.lean:110`
  (dead `affine`). Prover file `QcohTildeSections.lean` is 0-sorry. (A grep `sorry` hit at
  `CechAcyclic.lean:18` is a doc-comment, not a real sorry.)
- **Targets attempted:** 1 lane, `QcohTildeSections.lean` (`mathlib-build`).
- **Result: SOLVED.** +2 axiom-clean decls, 0 new sorries. The objective
  `isIso_fromTildeΓ_of_quasicoherent` landed, plus its component helper
  `isIso_fromTildeΓ_app_basicOpen`.

## Headline — the LAST 01I8 step landed; `qcoh_iso_tilde_sections` is now UNCONDITIONAL
This closes the Route B section-localization program (iters 040→048). For quasi-coherent
`F` on `Spec R`, the tilde–Γ counit `fromTildeΓ : tilde(Γ(X,F)) ⟶ F` is now proved to be an
isomorphism (Stacks 01I8, the affine structure theorem). Registered as an `instance`, it
upgrades `qcoh_iso_tilde_sections F` to hold **unconditionally** for quasi-coherent `F` —
the single input the 02KG vanishing tops, P5a, and P5b all gate on. The keystone
`qcoh_section_isLocalizedModule` (iter-047) was the load-bearing input; this iter was the
mechanical assembly the iter-047 handoff predicted.

## Target detail

### `isIso_fromTildeΓ_of_quasicoherent` (instance, line 1530) — SOLVED, axiom-clean
**Statement:** `(F : (Spec R).Modules) [F.IsQuasicoherent] : IsIso F.fromTildeΓ`.
**Proof structure (matches blueprint `lem:qcoh_isIso_fromTildeGamma` 4-step sketch):**
1. `suffices h : IsIso (modulesSpecToSheaf.map F.fromTildeΓ) from
   SpecModulesToSheafFullyFaithful.isIso_of_isIso_map F.fromTildeΓ` — reflect through the
   fully faithful forgetful functor. `suffices … from` defers the eager synthesis of the
   `[IsIso (F.map f)]` argument that a direct `apply` triggers.
2. `Functor.IsCoverDense.iso_of_restrict_iso` over the cover-dense basic-open subsite
   `inducedFunctor (fun r => specBasicOpen r)` (cover-dense via
   `TopCat.Opens.coverDense_inducedFunctor PrimeSpectrum.isBasis_basic_opens`; `IsLocallyFull`
   auto from `IsLocallyFull.of_full`).
3. Componentwise: `haveI : ∀ X, IsIso ((…op.whiskerLeft …).app X) := fun X =>
   isIso_fromTildeΓ_app_basicOpen F X.unop; exact NatIso.isIso_of_isIso_app _`.

**Attempts that failed first (each one debugging round):**
- `.val.app` → `Invalid field val: …InducedCategory.Hom.val` (TopCat.Sheaf morphisms project
  via `.hom`, not `.val`).
- bare `basicOpen` → `Unknown identifier basicOpen` (must fully qualify
  `PrimeSpectrum.basicOpen`), and then a space-unification failure
  (`↑?X =?= PrimeSpectrum R`) — fixed by routing through the project abbrev `specBasicOpen`
  so the basis functor lands in `(Spec R).Opens` and the Grothendieck topology unifies.
- `apply SpecModulesToSheafFullyFaithful.isIso_of_isIso_map` directly →
  `failed to synthesize IsIso (modulesSpecToSheaf.map F.fromTildeΓ)` (eager); fixed by
  `suffices … from`.
- `apply`-ing the cover-dense / app-iso hypotheses → eager synthesis fails; provide via
  `haveI` then `exact`.

### `isIso_fromTildeΓ_app_basicOpen` (private, line 1478) — SOLVED, axiom-clean
**Statement:** for qcoh `F`, `r : R`, the `D(r)`-component of `modulesSpecToSheaf.map
F.fromTildeΓ` is iso.
**Proof:** the component `c` satisfies `c.hom ∘ₗ tilde.toOpen.hom = ρ_r` (Mathlib's
`Scheme.Modules.toOpen_fromTildeΓ_app`, read at the `.hom`/LinearMap level via
`congrArg ModuleCat.Hom.hom` + `ModuleCat.hom_comp`). Both `tilde.toOpen.hom` (Mathlib
`IsLocalizedModule (powers r)` instance) and `ρ_r` (the **keystone**
`qcoh_section_isLocalizedModule F r`) localize `Γ(X,F)` at the powers of `r`; so `c.hom`
equals the canonical `IsLocalizedModule.linearEquiv` between the two localizations (proved
via `IsLocalizedModule.ext` with `hcl.map_units`, closing with `linearEquiv_apply`), hence
bijective. Conclude with `ConcreteCategory.isIso_iff_bijective`.
**Dead end avoided:** `IsLocalizedModule.linearEquiv_of_isLocalizedModule_comp` does NOT
exist in this Mathlib (loogle false positive); only `linearEquiv` / `linearEquiv_apply` /
`linearEquiv_symm_apply`.

## Soundness verification (review, first-hand)
- `lean_verify` on `isIso_fromTildeΓ_of_quasicoherent` = `{propext, Classical.choice,
  Quot.sound}`. No `sorryAx`. (Prover's full `lake env lean` was exit 0, deprecation
  warnings only.)
- The `change Function.Bijective ⇑c.hom` and `suffices … from` are genuine coercion-strip /
  problem-reduction, NOT the kernel-soundness spurious-rfl trap; the `IsLocalizedModule.ext`
  + `linearEquiv` + `e.bijective` closure is real (independently confirmed by lean-auditor
  `iter048`: 0 critical / 0 major; the `IsLocallyFull` auto-synthesis and the
  `NatIso.isIso_of_isIso_app` step are real synthesis paths, not vacuous subsingleton goals).

## Subagent reports
- **lean-auditor `iter048`** — CLEAN, 0 critical / 0 major / 4 minor (3× pre-existing
  `Sheaf.val` deprecation, 1× `maxHeartbeats` comment-placement). See
  `task_results/lean-auditor-iter048.md`.
- **lean-vs-blueprint-checker `iter048-qts`** — all clear, 0 red flags; 3 minor blueprint-side
  imprecisions (see recommendations). `task_results/lean-vs-blueprint-checker-iter048-qts.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_isIso_fromTildeGamma`: bundled
  `AlgebraicGeometry.isIso_fromTildeΓ_app_basicOpen` into the existing `\lean{...}` list (it is
  the component step of this exact lemma) — clears the only new `unmatched` Lean decl.
- `\leanok` on `lem:qcoh_isIso_fromTildeGamma` was added by the deterministic `sync_leanok`
  (iter 48, sha 6c51e96, +4) — genuine, the decl now compiles 0-sorry; left untouched.

## DAG / structural
- `archon dag-query gaps` = 0. `unmatched` = 2: the pre-existing dead
  `CechAcyclic.affine` + the now-bundled `isIso_fromTildeΓ_app_basicOpen` (clears after the
  `\lean{}` bundle above propagates next sync). **blueprint-doctor: no structural findings.**
- Frontier now exposes 4 ready nodes (01I8's completion unblocked the gated ones): see
  recommendations.md.

## Notes (LOW)
- `lean-auditor` flagged 3 pre-existing `Sheaf.val` deprecation warnings (lines 733/742/759)
  and a `maxHeartbeats` comment-placement pattern — cosmetic, non-blocking.
