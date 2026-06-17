# lean-auditor — iter-193 whole-project audit

## Scope

Audit every `.lean` file under the project tree
(`AlgebraicJacobian/**.lean` and `AlgebraicJacobian.lean`).

## Project root

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge`

## Focus areas (priority order)

1. **`AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`** — NEW file landed
   this iter (244 LOC). Verify:
   - 5 theorem skeletons under `AlgebraicGeometry.Scheme.Pic0` namespace
     match the chapter pins;
   - signatures are substantive (not vacuous);
   - universe handling for `AddEquiv` vs `LinearEquiv` (the file
     deliberately uses `AddEquiv` to bypass Type u vs Type (u+1)
     alignment between `IsLocalRing.CotangentSpace` and
     `Scheme.HModule`).

2. **`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`** — 8 new substrate
   helpers + body restructure on `degree_positivePart_principal_eq_finrank`.
   The signature is documented (in a `% NOTE` in the chapter) as STILL
   MATHEMATICALLY FALSE under the iter-193 `hlp` augmentation —
   counter-witness `K=K(C), t=u(u-1)`. Verify the new helpers are
   honest substrate (not vacuous over the false signature) and that
   the body uses them in the intended way (Y₀ extraction etc.).

3. **`AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`** — 2 new
   axiom-clean substrate helpers + private aux + `HModule_flasque_eq_zero`
   body restructure. Verify the strong-induction-with-F-quantifier
   structure is sound and the typed-sorry substrate inputs
   (`shortExact_app_surjective`, `injective_flasque`) are properly
   named.

4. **`AlgebraicJacobian/AbelianVarietyRigidity.lean`** — Lane E
   `IsOpenImmersion.lift_uniq` route refactor; `kbarChart1Ring` def
   + 2 conditional lemmas. Verify the new private helpers
   (`kbarChart1Ring`, `iotaGm_r_1_eq_specMap`, `kbarChart1Ring_specMap_fac`)
   are honest substrate.

5. **`AlgebraicJacobian/Picard/IdentityComponent.lean`** — 4 new private
   helpers (`identityComponentSection*`, `identityComponent_geometricallyConnected`,
   `geometricallyConnected_of_connected_of_section`). Verify the
   `@IsOpenImmersion.lift` explicit-form workaround did NOT introduce
   any soundness issues.

6. **`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`** — case
   split on `auslander_buchsbaum_formula` introduces 2 raw sorry
   tokens within a single declaration. Verify both branches are
   structurally honest.

7. **`AlgebraicJacobian/Albanese/CodimOneExtension.lean`** — Stages
   5a/5b helpers. Verify the Kähler-differential localisation chain
   is sound.

## What to look for

Per descriptor — per-file checklist of:
- Outdated comments referring to defunct iters / approaches.
- Suspect definitions (vacuous types, signatures that wouldn't compile
  without elaboration tricks, unused arguments, etc.).
- Dead-end proofs that gesture at substrate but don't actually use it.
- Bad Lean practices (deprecated API usage, unused universes,
  missing `noncomputable` markers, etc.).
- Documentation/code drift.

Pay extra attention to soundness: the WeilDivisor signature has been
flagged as FALSE; verify nothing else has this kind of issue.

## Output

Write your report to
`.archon/task_results/lean-auditor-iter193.md` per the wrapper's
standard path. Use the standard severity classes (CRITICAL / HIGH /
MEDIUM / LOW). The reviewing agent (me, iter-193 review) will lift
CRITICAL + HIGH into `recommendations.md` for the iter-194 plan agent.

## Strict context discipline

Do NOT read `STRATEGY.md`, `PROGRESS.md`, blueprint chapters, prior
session journals, or iter sidecars. Read ONLY the `.lean` files
listed above (+ Mathlib references on demand). Your value is the
unbiased Lean-as-Lean audit.
