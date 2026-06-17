# Recommendations for the next plan-agent iteration (iter-045)

## Highest-priority track: producer instance from the iter-044 algebraic input

**Track 1A (recommended primary, iter-045 prover lane):** producer instance `isHModuleHomFinite_toModuleKSheaf` providing `IsHModuleHomFinite k C (Scheme.toModuleKSheaf C)` on `C : Over (Spec (CommRingCat.of k))` integral with `[IsProper C.hom]`.

The iter-044 theorem `module_finite_globalSections_of_isProper` lands the *algebraic* input `Module.Finite k (Γ(C, ⊤))` (kernel-only axioms, file compiles). Iter-045 assembles it into the producer instance via the constant-sheaf / global-sections adjunction, in three substeps:

1. **`constantSheafΓAdj.homEquiv` lifted to a `LinearEquiv`** — between `((constantSheaf _).obj (ModuleCat.of k k) ⟶ toModuleKSheaf C)` and `(ModuleCat.of k k ⟶ (Sheaf.Γ).obj (toModuleKSheaf C))`. The homEquiv is the bare adjunction; the $k$-linear lift requires the $\Gamma$ functor to respect the $\Linear k$ structure on `Sheaf (J, ModuleCat k)`. **Mathlib probe required**: search for `Sheaf.Γ.linear` / `constantSheafΓAdj.linear` / similar lifts; if absent, the project may need a 5–15 LOC project-local lift.
2. **`(Sheaf.Γ).obj (toModuleKSheaf C) ≅ ModuleCat.of k Γ(C, ⊤)` as $k$-modules** — should be a defeq or 1–3 LOC `LinearEquiv` (the `Sheaf.Γ` functor on `ModuleCat k`-sheaves of $C.\text{left}$ evaluates to the global sections module).
3. **`Hom-from-`k`` ≅ `target` as $k$-modules**: `(ModuleCat.of k k ⟶ ModuleCat.of k M) ≃ₗ[k] M`. This is the standard "Hom out of the unit module" identification — Mathlib has `LinearMap.applyLinearEquiv` or similar. **Mathlib probe required.**
4. **Combine** via `Module.Finite.equiv` from the iter-044 theorem.

**Plan-agent action**: re-probe Mathlib HEAD this iteration for (a) the `Sheaf.Γ` linearity lift, (b) the Hom-from-the-unit identification. Both have plausible Mathlib backings; if they exist, the producer is a single-iteration close (~30–40 LOC). If either is absent, the producer is 1–2 iterations.

This track was queued as iter-044 fallback (Track 1A then Track 1B were equal-priority); iter-044 redirected to the *Stein input* because that was the only project-side algebraic content needed, and the producer-instance assembly is downstream of it.

## Equal-priority alternative: sharper Mayer-Vietoris LES consumer

**Track 1B (recommended, iter-045 prover lane):** combine the iter-029 LES with iter-040 + iter-041 + iter-042 + iter-043 + iter-044 consumers to produce a four-term finite-length LES on `HModule k F (n+1)` for the curve case.

Specifically: with iter-042's combined consumer + iter-043's wholespace H⁰ consumer (now backed by the iter-044 algebraic input plus the Track 1A producer instance once landed, or as a hypothesis for now), the LES finite-length transport at degree $\geq 0$ becomes a uniform statement. Plausibly single-iteration ~30–50 LOC. **Pick based on which has the tighter probe-confirmation circle.**

## Lower-priority tracks (for iter-045 fallback)

**Track 1C (alternative):** producer instance `isAffineHModuleVanishing_toModuleKSheaf` providing `IsAffineHModuleVanishing k C (Scheme.toModuleKSheaf C)`. **Multi-iteration likely** (50–100+ LOC, project-local Čech-vs-derived comparison + affine Čech vanishing). Lower priority — pick only if Tracks 1A + 1B both probe-fail.

**Track 1D (low-risk warm-up):** finrank corollary of iter-044 — a `Module.finrank_le_one`-flavoured restatement under `[IsProper]`. Marginal value; recommended only if Tracks 1A + 1B + 1C all probe-fail.

## Process discipline addition (iter-044 retro)

**New: probe `open`-list parity check.** The iter-044 prover's only corrective Edit was a name-resolution issue: the plan-agent's `lean_run_code` probe ran with a default `open Opposite` baseline but the target file lacks that open. The prover then had to qualify 7 occurrences of bare `op` to `Opposite.op`. To prevent recurrence:

- **Plan-agent should mirror the target file's `open` line in the probe scaffold** — specifically, copy lines `import …` through the first non-import line including any `open ...` from the target file into the probe before the body. This makes the probe environment identical to the file environment for name resolution.
- **Alternative (cheaper)**: scan the probe body for short names against the target file's `open` list as a final scoping step before handing off; expand any unqualified short name not in the union of `open`s.

Either is a 1-line addition to `.archon/prompts/plan.md`. Recommended: the latter (scan-and-expand) — it's mechanical and does not require maintaining the probe scaffold against open-list drift.

## Patterns to lean on (confirmed across iter-039 → iter-044)

- **Verbatim probe-confirmed body, single substantive Edit** — when the plan-agent's `lean_run_code` probe returns clean diagnostics, the prover lands the body verbatim. **8 of 10 iterations zero-corrective-Edit, 2 with 1 cosmetic corrective.** The corrective rate has held at 0–1 cosmetic Edit per iteration for ten consecutive iterations.
- **Stein-finiteness packaging via `finite_appTop_of_universallyClosed` + `RingHom.finite_algebraMap` + `Module.Finite.of_equiv_equiv`** — new from iter-044; reusable for any "proper integral scheme over a base, transport finiteness from intermediate to base" pattern.
- **`Iso.commRingCatIsoToRingEquiv` for transport along `Scheme.ΓSpecIso`** — new from iter-044; reusable.
- **Carrier + immediate consumer + curve-specialisation triple-declaration package** — iter-043 introduced this packaging; reusable for any future "single-degree-side carrier+consumer+curve" cohort.
- **`class IsX ... + theorem foo_of_isX`** when the class hypothesis carries explicit args (`k`, `C`, `F`, `hU`) that block typeclass resolution at the consumer level.
- **Named-args `IsX.field (k := k) (C := C) (F := F)`** when the class field's type does not pin down all type variables.

## Closed targets to NOT retry

- All declarations in iter-006 → iter-044 (90 declarations) closed in `Cohomology/StructureSheafModuleK.lean` and `Cohomology/MayerVietoris.lean` — kernel-only axioms intact.
- The 5 `Jacobian.lean` protected sorries — Phase C step 4 (FGA representability) plus `noncomputable` user-decision.
- The 3 `AbelJacobi.lean` protected sorries — structurally downstream of `Jacobian C` plus `noncomputable` user-decision.
- `PicardFunctor.representable` — intentionally deferred; closing on the global-sections-approximate `LineBundle` would silently assert representability of the wrong functor.
- Re-introducing the `Scheme.` short-name prefix inside `namespace AlgebraicGeometry.Scheme` — known-dead-end #185.
- Switching iter-040's H${}^{>0}$ `Subsingleton` formulation to `Limits.IsZero`.
- Switching iter-043's `IsHModuleHomFinite` field type to `Subsingleton` or `IsZero` — `Module.Finite` is the correct and natural shape.
- Erasing iter-041's `IsAffineHModuleHomFinite` or iter-042's combined consumer — they remain valid for non-curve use cases.
- Changing the iter-044 `[IsIntegral C.left] [IsProper C.hom]` hypothesis combination — these are the cleanest direct interface; consumers can derive `IsIntegral` from `GeometricallyIrreducible` + smoothness on a $k$-curve in their own context.
