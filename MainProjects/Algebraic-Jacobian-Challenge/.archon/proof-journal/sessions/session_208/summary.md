# Session 208 — Review summary (iter-208)

## Metadata
- **Session / iter**: session_208 = review of iter-208
- **Sorry count**: global **80 → 80** (net 0); TS file `Picard/TensorObjSubstrate.lean` **3 → 3**.
- **Build**: GREEN. **0 `axiom` declarations** (blueprint-doctor confirms project-wide; no orphan chapters, no broken `\ref`/`\uses`).
- **Lane dispatched**: 1 — Lane TS (`Picard/TensorObjSubstrate.lean`), `prove` mode, on the iter-208 "Route A" reset.
- **HARD BAR**: the critical-path closure (`tensorObj_restrict_iso`) **NOT met**. One genuine, verified reduction step added (not cosmetic).

## The defining event — the armed reversal pre-commitment FIRED

The iter-208 plan committed to **Route A** for `tensorObj_restrict_iso` on the
premise (from `analogies/tsroute208.md`) that the residual was *"a bounded ~30–60
LOC sectionwise unfolding of `PresheafOfModules.pullback` along the open
immersion"*. The plan armed an explicit reversal pre-commitment:

> "the prover finding that the sectionwise `pullback`-unfolding helper cannot be
> stated/closed without the abstract monoidal machinery after all (i.e. the
> `pullback` opacity is not crackable sectionwise) … If so, Route A joins the
> δ-route as multi-file-blocked and TS pauses (option c)."

**The prover returned exactly that finding.** `PresheafOfModules.pullback φ.hom`
is the *opaque abstract left adjoint* `(pushforward φ.hom).leftAdjoint`
(`Presheaf/Pullback.lean:44`) — it has **no sectionwise formula**. The Route-A
recipe conflated the opaque `pullback` with the *concrete* `pushforward`:
`restrict_obj` is `rfl` precisely because `M.restrict f = restrictFunctor f =
SheafOfModules.pushforward β` (a pushforward), NOT a pullback. The "30–60 LOC"
estimate is wrong by ~5×. The same opacity caused the kaehler precedent
(`analogies/...presheafpullback` Decision 5) to EXCISE its analogous unfolding.

So the pre-committed reversal signal has fired: **Route A is not closable in
`prove` mode.** This is the loop working as designed — the planner armed the
exit, and it triggered on first contact.

## What was genuinely banked (one real reduction step)

The prover did NOT merely fail. It added a **third verified reduction step** to
`tensorObj_restrict_iso` (compiles GREEN, confirmed via `lean_goal`):

```lean
-- Step 3: strip the outer sheafification
refine (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).mapIso ?_
```

Both sides of the goal are `sheafification.obj _`, so this reduces the goal from
a sheaf-level iso to the precise **presheaf-level residual**
`(PresheafOfModules.pullback φ.hom).obj (M.val ⊗ₚ N.val) ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`
(verified to contain no sheafification). The file now formalizes Steps 1–3
(`restrictFunctorIsoPullback` → `sheafificationCompPullback` → `mapIso`); only
Step 4 (the presheaf residual) is `sorry`. This is permanent, correct
infrastructure whatever route closes the residual.

## The corrected decomposition (precise, recorded)

The genuine route needs **two project-side ingredients, both Mathlib-absent**
(full detail in `informal/tensorObj_restrict_iso.md` + the in-code comment
L357–398):

- **H1 (linchpin, ~100–150 LOC)**: a PRESHEAF-level iso `pushforward β.hom ≅
  pullback φ.hom` via `Adjunction.leftAdjointUniq`, from a presheaf-level
  `pushforward β.hom ⊣ pushforward φ.hom` (presheaf analogue of the sheaf-level
  `SheafOfModules.pushforwardPushforwardAdj`). Needs presheaf-level
  `pushforwardNatTrans` + `pushforwardCongr` — only the SHEAF versions exist.
- **H2 (~60–100 LOC)**: strong-monoidal comparison `(pushforward β.hom).obj
  (A ⊗ₚ B) ≅ (pushforward β.hom).obj A ⊗ₚ (pushforward β.hom).obj B`. Since
  `pushforward = pushforward₀ ⋙ restrictScalars` and `pushforward₀OfCommRingCat`
  is already `Monoidal`, this reduces to upgrading the file's lax
  `restrictScalarsLaxMonoidal` to STRONG via `Functor.Monoidal.ofLaxMonoidal`.
  `IsIso ε` is easy; `IsIso μ` bottoms out in the absent Mathlib lemma
  **"`ModuleCat.restrictScalars` along a ring iso is strong monoidal"**
  (`extendScalars` is `Monoidal`, `restrictScalars` only `LaxMonoidal`) —
  a self-contained ~30–50 LOC algebra lemma worth building FIRST.

Closure: `(pullback φ.hom)(M.val⊗ₚN.val) ≅[H1.symm] (pushforward β.hom)(M.val⊗ₚN.val)
≅[H2] (pushforward β.hom M.val) ⊗ₚ (pushforward β.hom N.val) =defeq (M.restrict f).val ⊗ₚ (N.restrict f).val`.

**Dead ends (do NOT retry)**: abstract mate-δ via `(pullback φ).Monoidal`;
"sectionwise unfold the opaque pullback"; adding `IsLocallyTrivial` hypotheses.

## The recession pattern — now in its 4th maturation iter

This is the FOURTH consecutive iter the TS lane has landed "the foundational
input" while the critical-path sorry count held flat:
- iter-205: cone reduced to one fact (`whiskerLeft`), 0 sorries closed.
- iter-206: two reduction steps + pinned residual, net −1 (dead-instance removal).
- iter-207: `restrictScalarsLaxMonoidal` built axiom-clean, "sole ingredient" premise disproven.
- iter-208: one reduction step (`mapIso`), Route-A "30–60 LOC" premise disproven; pre-commitment fired.

Each iter found a fresh "almost there" framing and dispatched again; each time the
new framing was disproven on contact, leaving real banked infrastructure but no
closed critical-path sorry. The planner's armed pre-commitment this iter is the
correct mechanism — it forecloses a FIFTH "one more framing" dispatch. The next
planner must pick: a dedicated `mathlib-build` lane on ingredients (1)–(4), or
pause TS + pivot (the pre-commitment's stated `option c`).

## Other prover notes
- **Informal agent unavailable**: the only key present (`MOONSHOT_API_KEY`) is a
  "Kimi For Coding" subscription key, rejected by the chat-completions API (403
  `access_terminated_error` on `api.kimi.com/coding`; 401 on `api.moonshot.cn`).
  Usable only through coding-agent front-ends, not as a literature/sketch oracle.

## Subagent findings landed
- **lean-vs-blueprint-checker ts-iter208**
  (`task_results/lean-vs-blueprint-checker-ts-iter208.md`): Lean is FAITHFUL (all
  8 pinned decls exist, correct signatures, 3 expected sorries honestly labelled,
  in-code analysis comment is accurate workflow doc, NOT excuse-laundering). The
  **must-fix is on the BLUEPRINT side**: the proof block Step 3 main prose +
  closing "30–60 line helper" paragraph, AND two secondary sections (API survey
  intro ~L155–177; LOC estimates Piece 2 ~L963–990) still assert the **disproven**
  sectionwise-unfolding route — a prover reading the chapter is steered into the
  dead end. My `% NOTE:` covered only the proof block; a blueprint-writer rewrite
  to the H1/H2 route is required next iter (see recommendations.md #2).
- **lean-auditor iter208**: see recommendations.md (landed there).

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, proof of `lem:tensorobj_restrict_iso`: added
  `% NOTE:` flagging that Step 3 (sectionwise-unfolding ~30–60 LOC) was DISPROVEN
  by the iter-208 prover, with the corrected H1/H2 decomposition and pointers to
  `informal/tensorObj_restrict_iso.md` + task_results.

No `\leanok` added/removed (deterministic sync owns it; sync_leanok-state.json
iter=208 confirms the tree is current — the statement-block `\leanok` on
`lem:tensorobj_restrict_iso` is the script's legitimate verdict, decl-exists-with-sorry).

## Recommendations
See `recommendations.md`. Headline: TS Route A is `prove`-mode-blocked (the
pre-commitment fired); next planner picks mathlib-build lane vs pause+pivot. The
blueprint chapter needs a writer pass to rewrite the disproven route BEFORE any
re-attempt.
