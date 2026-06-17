# Recommendations for iter-220 (plan agent)

## Headline

iter-219 landed the **first brick of the funded ⊗-dual internal-hom infra block** axiom-clean (`homModule`/`internalHomObjModule`, the per-object value module). This is the deliberately-committed multi-iter build (analogist ts219dual: ~6–12 iters / ~300–500 LOC), so the net-zero sorry count is EXPECTED, not a stall — the brick is genuine forward progress (both review subagents = 0 must-fix; axiom-clean re-verified first-hand). **Continue the build.** Do NOT re-dispatch `prove` on `exists_tensorObj_inverse` or `addCommGroup_via_tensorObj` — they remain infrastructure-blocked until the dual presheaf+eval+sheafify land (the iter-214 d.1 / iter-218-gate anti-pattern guard stands).

## Closest-to-completion / next prover target (CONTINUE the build)

**`Picard/TensorObjSubstrate.lean`, mode `mathlib-build` — the NEXT sub-step: restriction maps + presheaf assembly.** Precise handoff from the prover task result:
1. **Restriction maps.** For `g : V ⟶ U` in `C`, build the `R(U)`-semilinear (over `R(g)`) map `(M|_U ⟶ N|_U) → (M|_V ⟶ N|_V)` via `Over.map g : Over V ⥤ Over U` (precompose `_ ≫ g`), restricting a morphism over `Over U` to one over `Over V`. Verify `(Over.forget V).op ⋙ R = (Over.map g).op ⋙ (Over.forget U).op ⋙ R` (expected `rfl`, mirroring the associativity `rfl` already used).
2. **Presheaf assembly** (the bulk). Package `U ↦ ModuleCat.of (R(U)) (M|_U ⟶ N|_U)` + the step-1 maps into `PresheafOfModules R` via `PresheafOfModules.ofPresheaf` (underlying `Cᵒᵖ ⥤ Ab` + per-object `internalHomObjModule` + `map_smul` compatibility). **Gotcha carried forward:** `ModuleCat.of` of the hom-module is fragile under `letI`; construct the `ModuleCat` value with all instances explicit (`@ModuleCat.of … AddCommGroup Module`).
3. Only THEN: `def:presheaf_dual` = `internalHom M (unit R)`; `lem:internal_hom_eval`; `lem:internal_hom_isSheaf` (sheafify → `Scheme.Modules.dual`); `lem:dual_isLocallyTrivial`; finally `exists_tensorObj_inverse` via `rem:dual_discharges_inverse`.

## MUST-FIX / HARD-GATE before that prover dispatch (blueprint-side, from lvb ts219)

The lvb checker flagged the **presheaf-assembly restriction-map step as under-specified** in `Picard_TensorObjSubstrate.tex` (no Lean target name / signature for the `V ⟶ U` restriction map). Per the HARD GATE, before dispatching the next prover on this file:
- Dispatch a **blueprint-writer** on `Picard_TensorObjSubstrate.tex` to (a) add a named sub-block (e.g. `lem:presheaf_internal_hom_restriction_map`) with a Lean target name + signature for the restriction map `ρ : internalHomObjModule U M N → internalHomObjModule V M N` for `g : V ⟶ U`, before the `PresheafOfModules.mk`/`ofPresheaf` assembly; and (b) add intermediate `\lean{}` pins / a sub-definition block for `PresheafOfModules.InternalHom.homModule` and `…internalHomObjModule` so iter-219's progress is visible in the blueprint. (Source: `references/stacks-modules.tex` §Internal Hom; analogist `analogies/ts219dual.md`.) Then re-run the scoped blueprint-reviewer fast-path to clear the gate.
- A `% NOTE:` recording this was added to `def:presheaf_internal_hom` by the review agent this iter.

## MEDIUM — ride-along Lean cleanup (lean-auditor ts219, 2 major + 4 minor, all stale comments)

No code is wrong; the file carries stale block comments that misrepresent the implementation/sorry state of OLDER decls. Fold into the next prover directive as a ride-along (the prover owns this file):
- **L37–85** block comment "Status (iter-202 Lane TS — file-skeleton scaffold)" claims the 4 pinned decls "carry a `sorry` body" and "bodies are iter-203+ work" — FALSE now (`tensorObj` L1151, `tensorObj_functoriality` L1166, `tensorObjOnProduct` complete; the `monoidalCategory` instance was removed). Update or delete.
- **L1567** `tensorObjOnProduct` docstring ends "iter-202 Lane TS scaffold: typed `sorry`" but body is a complete `⟨tensorObj …, tensorObj_isLocallyTrivial …⟩`. Misleads sorry-counters. Fix.
- Minor: L1201 ("scaffold the iter-203+ bodies"), L1271 (`tensorObj_assoc_iso` "iter-212 status (typed sorry)" — body is real, sorry is transitive via L632), L1588 (`addCommGroup_via_tensorObj` stale iter numbers). Update iter references.

## MEDIUM — sync_leanok under-marking (for plan agent awareness)

`lem:presheaf_pushforward_adj_substrate` (5 axiom-clean decls, iter-217) and `lem:tensorobj_unit_iso` (2 sorry-free decls) lack `\leanok` despite sorry-free Lean. sync ran this iter (+0/−0) so this is the script's standing verdict, not stale markers. Likely the multi-decl `\lean{a,b,c,…}` block requiring every named decl to resolve, or a block-form quirk. Worth the plan agent verifying the `\lean{}` pin lists match the actual decl names; if they do and `\leanok` still doesn't sync, it's a sync-script limitation to note (not a correctness issue — the decls ARE axiom-clean per lvb ts219).

## DO NOT retry (blocked — do not re-assign `prove`)
- **`exists_tensorObj_inverse`** (L1559): infrastructure-blocked on the full internal-hom/dual presheaf. Unblocks only after steps 1–3 above. Forbidden to `prove`-probe.
- **`addCommGroup_via_tensorObj`** (L1603): downstream of `exists_tensorObj_inverse`. Same block.
- **`isLocallyInjective_whiskerLeft_of_W`** (L632): vestigial; the assoc re-route + deletion is the deferred SECONDARY, blocked on the same `SheafOfModules` morphism descent. Mooted once `tensorObj_assoc_iso` is re-routed onto the closed `tensorObj_restrict_iso`. Do not `prove`-probe.

## Standing strategic note (planner already surfaced; for context)
The whole ⊗-substrate is Route-A-specific. The iter-219 planner re-surfaced the standing USER escalation: if the USER lifts the ROUTE C PAUSE, `Pic⁰` could instead be built via the divisor/Abel–Jacobi route (Kleiman §5; project already has `WeilDivisor`/`OcOfD`), discarding the entire substrate. The loop proceeds on the funded internal-hom build unless USER_HINTS.md overrides. No action needed from the plan agent beyond awareness; this is the project's single highest-leverage decision and is already FYI'd to the user.
