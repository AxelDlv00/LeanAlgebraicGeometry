# Recommendations — for the iter-213 plan agent

## CRITICAL — the associator route has a real blueprint gap; treat as reversal-class

**`tensorObj_assoc_iso` is BLOCKED, not residual.** The iter-212 designated go/no-go
bridge cleared axiom-clean, but the obstruction was never the bridge — it is the
**flatness feeder**. Independently confirmed by `lean-vs-blueprint-checker ts212`
(report: `.archon/task_results/lean-vs-blueprint-checker-ts212.md`, Q1–Q2):

- `W_whiskerLeft/Right_of_flat` require `[∀ U : (Opens X)ᵒᵖ, Module.Flat (𝒪_X(U)) (M.val.obj U)]` — **sectionwise flatness over every open**.
- `IsInvertible M` is a **global/sheaf-level** existential (`∃ N, tensorObj M N ≅ 𝒪_X`); it does NOT give sectionwise `Module.Invertible (𝒪_X(U)) (M.val.obj U)`, and over a non-affine open it is **false** (sections functor not exact).
- The blueprint's "invertible ⇒ projective ⇒ flat" step (`lem:tensorobj_assoc_iso`, "Flatness is free") is **mathematically incorrect**. I have `% NOTE`-flagged it (proof + overview prose).

**Do NOT re-dispatch a prover on `tensorObj_assoc_iso`** until the blueprint step is
rewritten and a scoped `blueprint-reviewer` re-clears the chapter (HARD GATE — the
chapter is now `correct: false` on this proof). Per the prover and the checker the
strategic fork is:
- **(i) rescope** `IsInvertible` / `lem:tensorobj_assoc_iso` to carry a local-freeness hypothesis — but the CommMonoid consumer only has `IsInvertible`, so this still needs `IsInvertible ⇒ IsLocallyTrivial ⇒ local-free` first;
- **(ii) build the local-triviality whiskering lemma** (`IsLocallyTrivial.whiskerLeft_of_W` or similar: on the cover where `M ≅ 𝒪`, `η ▷ M ≅ η` is locally `J.W`) + a sieve-refinement rerun — **~150–250 LOC, multi-iter**;
- **(iii) ESCALATE to USER.**

⚠️ **Strategic caution for the planner.** Option (ii) re-introduces the
local-trivialization machinery that the **iter-209/210 pivot deliberately abandoned**
to escape the `tensorObj_restrict_iso` wall. The pivot's headline promise was
"flatness is free, no local trivialization" — that premise is now disproven. Combined
with three restructure iters (209/210/211) + this gate-clear all producing **zero
critical-path closure**, this is a **reversal-class event**, even though the
pre-committed reversal trigger (worded as "bridge bottoms out in `MonoidalClosed`")
did not fire as worded. **Run `progress-critic` and a `strategy-auditor`/`strategy-critic`
pass before committing more prover effort, and seriously weigh escalation (iii).**

## CRITICAL — group-law engine declaration is MISSING from Lean

`lean-vs-blueprint-checker ts212` found that
`AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid` (blueprint
`lem:tensorobj_isoclass_commgroup`, the ⊗-iso-class commutative-monoid engine) **does
not exist anywhere in the Lean file**, despite being `\lean{}`-pinned and being the
declaration `addCommGroup_via_tensorObj` (`thm:rel_pic_addcommgroup_via_tensorobj`)
depends on. It is also downstream of the blocked associator (it `\uses` it), so it
cannot close until the associator route is fixed. **Plan agent: scaffold this decl
only after the associator blueprint is corrected** — scaffolding it now would inherit
the associator's sorry and the flatness gap.

## Closest-to-completion / landed this iter (do NOT re-assign)

- ✅ `PresheafOfModules.isIso_sheafification_map_of_W` — CLOSED, axiom-clean. The
  load-bearing localization bridge (`inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`,
  3-line proof). **Auditor: GENUINE CLOSE, non-vacuous.**
- ✅ `PresheafOfModules.W_whiskerRight_of_flat` — CLOSED, axiom-clean. Braiding-conjugate
  of `W_whiskerLeft_of_flat`. **Auditor: GENUINE CLOSE.**

**Blueprint pins to ADD (plan-agent prose action — NOT a marker the review agent owns):**
both new sorry-free helpers are substantive and consumed by the associator proof but
have no `\lean{}` pin. Add `\lean{PresheafOfModules.W_whiskerRight_of_flat}` to the
`lem:flat_whisker_localizer` block, and a small new block for
`PresheafOfModules.isIso_sheafification_map_of_W` (the go/no-go bridge). (`lean-vs-blueprint-checker`
majors #3, #4.)

## Blocked targets — do NOT retry as-is

- `tensorObj_assoc_iso` via `∀ U, Module.Flat (𝒪_X(U)) (P.val U)` from `IsInvertible` — **not provable, likely false.** Do NOT use `W_whiskerLeft/Right_of_flat` with `F = M.val/P.val` directly.
- `tensorObj_restrict_iso`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` — pre-existing off-path / downstream sorries; unchanged this iter; not on the active route.

## Reusable proof patterns discovered

- **Sheafification IS localization:** `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` reduces "`J.W f ⇒ IsIso (sheafification.map f)`" to a 3-line rewrite — no manual toPresheaf-reflects-isos + compatibility-iso recipe needed.
- **Braiding conjugation needs explicit reassociation:** `braiding_naturality_left` matches a 2-term composite; for the 3-term `(β).hom ≫ (F◁g) ≫ (β).inv`, use `rw [← Category.assoc, ← braiding_naturality_left g F, Category.assoc, Iso.hom_inv_id, Category.comp_id]`.

## Hygiene findings to fold into a near-future cleanup (lean-auditor ts212)

Not blocking, but recommend a `refactor`/cleanup directive on `Picard/TensorObjSubstrate.lean`
(none are must-fix; report: `.archon/task_results/lean-auditor-ts212.md`):

- **MAJOR — deprecated `CategoryTheory.Sheaf.val` API (×11 sites: L409,426,471,488,490,500,502,510,512,520).** `.val` on `Sheaf` is deprecated for `ObjectProperty.obj`; present in sorry-free defs; **will silently break on the next Mathlib bump.** This is the *same* `X.ringCatSheaf.val` defeq-not-syneq object that compounded BLOCKER 2 on the associator (heartbeat timeouts) — worth fixing for both reasons.
- **MAJOR — unexplained `set_option backward.isDefEq.respectTransparency false` (L111,127,144)** in the `restrictScalars` lax-monoidal supplement, no comment on which defeq failure it suppresses or why it is safe. Latent fragility.
- **MAJOR — stale module-doc + inline timestamps** (L37–45 "iter-202 file-skeleton scaffold"; L406/419/738/773 "iter-203+ closure target"): 10 iters stale, give a false near-term-closure impression. Update to iter-212 state.
- **MINOR:** unused `ext r` (L120); spurious `@[implicit_reducible]` on sorry-bodied def (L780); `Ab.{u}` vs `AddCommGrpCat` instance-arg inconsistency (L332 vs L376); informational `opaque` warning at L669 (false positive — comment text, from `tensorObj_restrict_iso`'s documented opaque `pullback`).

## One-line for the planner

The pivot's load-bearing premise ("⊗-invertible ⇒ flat, free") is **disproven**; the
correct fix loops back toward the abandoned local-trivialization wall. Gate the
associator behind a blueprint rewrite, scaffold the missing CommMonoid only after,
and treat this as a reversal-class decision point — `progress-critic` +
`strategy-auditor` before more prover spend.
