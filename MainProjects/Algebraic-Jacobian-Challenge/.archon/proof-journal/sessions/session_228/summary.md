# Session 228 — review of iter-228

## Metadata
- **Iteration / session:** iter-228 / session_228
- **Prover:** 1 × `mathlib-build` (opus), file `Picard/TensorObjSubstrate.lean`
- **Status:** PARTIAL — but the SHARPENED success bar (C-bridge FULL axiom-clean) was **NOT met**; the **hard-block condition fired**.
- **Project sorry:** 80 → 80 (no sorry eliminated; no sorry pinned).
- **File sorry:** 3 → 3 (all pre-existing: L691, L2165 `exists_tensorObj_inverse`, L2211 `addCommGroup_via_tensorObj`).
- **Build:** GREEN, 0 errors (re-verified first-hand). Only pre-existing `Sheaf.val` deprecation + `opaque` warnings.

## Headline — the C-bridge is GENUINELY BLOCKED; the "verbatim mirror" blueprint claim is empirically falsified

The iter-228 directive set a **sharpened C success bar**: the C-bridge `dual_isLocallyTrivial`
had to land **FULL axiom-clean** to count as route progress; a helpers-only partial was
declared explicitly NOT progress (would repeat iter-227). It also wired a **hard-block
condition**: a *genuine* failure to land axiom-clean (a true block, not mid-build budget
exhaustion) makes the standing USER escalation **bind**.

The prover delivered exactly the hard-block input. It drafted the requested verbatim mirror
of the closed `tensorObj_restrict_iso`, and read off the residual via `lean_goal`:

- **Steps 1–3 + H1 of the mirror typecheck cleanly for the dual** (no errors), exactly as the
  blueprint predicted: `restrictFunctorIsoPullback` → `sheafificationCompPullback` →
  strip-sheafification (`.mapIso`) → H1 (`pushforwardPushforwardAdj.leftAdjointUniq`).
- The residual after H1 is **exactly**:
  ```
  (pushforward β).obj (PresheafOfModules.dual A) ≅ PresheafOfModules.dual ((pushforward β).obj A)
  ```
  — open-immersion pushforward commuting with the presheaf dual.
- **This does NOT close via H2′ / `restrictScalarsRingIsoDualEquiv` as the blueprint claims.**
  The tensor's H2 worked because `tensorObj M N` is **SECTIONWISE** `M(U) ⊗_{R(U)} N(U)` — a
  literal `restrictScalars`-image, so the strong-monoidal tensorator (`restrictScalarsMonoidalOfBijective`)
  applies. But `dual = internalHom(-, 𝟙_)` is the **SLICE internal hom**: its value is a
  morphism-module over `Over U` (a compatible family over all `V ≤ U`), **not** a sectionwise
  `restrictScalars`-image. There is therefore **no sectionwise strong-monoidal-closed analogue**
  for the dual, and `restrictScalarsRingIsoDualEquiv` (built iter-227) is only the ModuleCat-level
  shadow — it cannot be lifted the way the tensor's `restrictScalarsRingIsoTensorEquiv` was.
- **The genuine missing infrastructure:** the **open-immersion slice-site equivalence** — for
  `V ∈ Opens Y`, `Over V` (in `Opens Y`) ≅ `Over (f''V)` (in `Opens X`), transporting the
  morphism-modules naturally, plus compatibility with `restr`/`pushforward₀`. A **Mathlib-absent
  ~150–300 LOC build** (`Over.map`/equivalence pseudofunctor coherence). **NOT a verbatim mirror,
  NOT discharged by `restrictScalarsRingIsoDualEquiv`.**

The prover correctly classified this as a **genuine block (route bottoms out at H2′), not
mid-build budget exhaustion**, and did **not** stub it (no sorry). This is the precise
hard-block input the iter-228 plan pre-committed to: the USER escalation now binds.

Verified first-hand this review: build GREEN, 0 errors; the three new decls all
`lean_verify` = `{propext, Classical.choice, Quot.sound}` (axiom-clean); the placeholder
`\lean{}` pin `lem:dual_isLocallyTrivial` points at a Lean decl that does not exist.

## What DID land (3 axiom-clean helper decls — the "dual respects isos" ingredient)

All three re-verified axiom-clean this review:
- **`PresheafOfModules.dualPrecompEquiv`** (L1558) — section-level `R(U)`-linear precomposition
  equivalence on dual sections (`φ ↦ (pushforward₀(Over.forget U)).map e.hom ≫ φ`).
- **`PresheafOfModules.dualIsoOfIso`** (L1603) — presheaf-level "dual respects isos"
  (`e : M ≅ M' → dual M' ≅ dual M`), naturality discharged by default `cat_disch`.
- **`AlgebraicGeometry.Scheme.Modules.dualIsoOfIso`** (L1698) — sheaf-level "dual respects isos",
  the dual analogue of `tensorObjIsoOfIso`.

These are genuine reusable infrastructure (the contravariant-functoriality ingredient of the
`dual_isLocallyTrivial` assembly), but per the sharpened bar they are **helpers, not route
progress**: the assembly is blocked upstream on the restrict-iso, which they do not touch.
Notably the prover observed that the dual IS cleanly contravariantly functorial in isos
(the `cat_disch` discharge) — confirming the slice obstruction is **specific to the
open-immersion pushforward commutation**, not to iso-functoriality.

## Bounded attempt abandoned (not stubbed)
- **`dual_unit_iso`** (`internalHom 𝟙_ 𝟙_ ≅ 𝟙_`, second assembly ingredient) — the rank-one
  lemma `globalSMul_unit_eq` blocked immediately on unit plumbing: `(restr U 𝟙_).obj (op (Over.mk (𝟙 U)))`
  has no `OfNat 1` instance (the unit generator must go through `PresheafOfModules.unit`'s section
  API, cf. `unit_map_one`, not a bare ring `1`). Removed, no sorry. Off the critical path.

## The arc — 12th consecutive iter with no project-sorry-elim since iter-217

The 219→228 descent re-route arc is bridge/helper accretion: each iter lands axiom-clean
infrastructure but `exists_tensorObj_inverse` (80→79) never closes. iter-228 is the **12th
consecutive iter with no genuine downward move in the project sorry counter since iter-217**.
What is *newly decisive* this iter (vs the prior "strongly-evidenced but unproven" reads):
the lower-risk C-bridge — chosen iter-228 precisely because the blueprint billed it a verbatim
mirror of the closed tensor linchpin — is now **empirically a genuine block**, not a quick win.
The route's remaining cost just grew (slice-site equivalence ~150–300 LOC on top of the
A-engine ~120–190 LOC), and the framing that justified the low-risk C-primary choice was
falsified. The d.2-freeness of the route is *unchanged* (the slice reindexing is structural,
not a stalk), so the deep-math risk stays retired — but "d.2-free" was never the binding cost;
build size is, and it is now materially larger than the frozen ~3–4-piece estimate implied.

## Process correctness
- **Prover: textbook.** Ran the decisive empirical probe, read off the exact residual via
  `lean_goal`, correctly diagnosed the slice-vs-sectionwise mismatch, refused to stub the
  blocked bridge, landed 3 axiom-clean on-path helpers, abandoned (not stubbed) the off-path
  `dual_unit_iso`, and returned a precise, actionable hard-block report. Honoured all FORBIDDEN
  constraints (no new sorry, no sheafify shortcut, no `maxHeartbeats`, no d.2 whiskering).
- **Planner (iter-228): the pre-commitment now binds.** The iter-228 plan ACCEPTED the
  progress-critic STUCK+OVER_BUDGET verdict, sharpened the C bar, and wired the hard-block
  condition. That condition is now triggered: the USER escalation (lift the RR pause → divisor
  `Pic⁰`, discarding the substrate) binds. This is the correct, pre-agreed outcome — not a
  planner error. The one open process question for iter-229: with the C-bridge genuinely
  blocked, the bounded committed runway's first piece failed, so iter-229 cannot simply
  "continue building C"; it must either (a) take on the newly-scoped slice-site equivalence as
  a fresh sub-build, or (b) hold the route pending the USER fork. Both are surfaced in
  recommendations.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:dual_isLocallyTrivial`: added `% NOTE:` (iter-228)
  documenting that the "verbatim mirror" proof sketch is **incorrect past Step 3/H1** — the
  H2′ residual is the slice-internal-hom-vs-sectionwise mismatch, needing the Mathlib-absent
  open-immersion slice-site equivalence, NOT `restrictScalarsRingIsoDualEquiv`. (The `\lean{}`
  pin is left in place — the target Lean decl does not yet exist; this is the planner/writer's
  to repair via prose, not a marker the review agent strips.)

## Blueprint doctor
CLEAN — no orphan chapters, no broken `\ref`/`\uses`/`\proves`, no new `axiom` declarations.

## sync_leanok attribution
`sync_leanok-state.json`: iter 228, sha `2f21b101`, **+2 / −0**, chapter
`Picard_TensorObjSubstrate.tex`. The +2 are the two new C-bridge-adjacent blocks added by the
iter-228 blueprint-writer (`lem:restrictscalars_ringiso_dualequiv` / `def:scheme_modules_homMk`)
whose Lean decls landed iter-227. No laundering: the new helper decls (`dualPrecompEquiv`,
`dualIsoOfIso` ×2) are not yet `\lean{}`-pinned, so `sync_leanok` did not (and could not) touch them.

## Review subagents
See `recommendations.md` for landed findings (lean-vs-blueprint-checker tensorobj228,
lean-auditor ts228).

## Recommendations for next session
See `recommendations.md`. Headline: the C-bridge verbatim-mirror route is empirically dead at
H2′; the USER escalation binds. Do NOT re-dispatch the verbatim mirror. The live planner choice
is (a) scope the slice-site equivalence as a fresh ~150–300 LOC build vs (b) hold pending the
USER's RR-pause fork.
