# Recommendations — after iter-238

## Headline
**The ~20-iter Picard group-law bottleneck is CLOSED.** `picCommGroup : CommGroup (PicGroup X)`
landed axiom-clean (`{propext, Classical.choice, Quot.sound}`, re-verified by the review agent),
together with `PicGroup`, `IsInvertible.tensorObj`, `isInvertible_unit`, `IsInvertible.inverse_unique`,
`tensorObj_assoc_iso_invertible`, and the now-**unconditional** `tensorObj_assoc_iso`. Both
review subagents (`lean-auditor`, `lean-vs-blueprint-checker`) independently confirmed the §5
construction is genuine, non-vacuous, and faithful to the blueprint — **0 must-fix blocking findings.**

## Closest-to-completion / next units (the counter moves here)
The group law is the *ingredient*; the canonical counter (`exists_tensorObj_inverse` L693,
`PicSharp.addCommGroup_via_tensorObj` L891) is now **reachable wiring**, not invention:

1. **Re-open Lane RPF (`RelPicFunctor.lean`) onto `IsInvertible`/`PicGroup`** (prover's #1 handoff).
   Re-base its presheaf/subgroup onto the new `IsInvertible`/`PicGroup` and replace the dishonest
   `PicSharp := const PUnit` / `functorial := 0`. This is the path to closing the deferred
   `addCommGroup_via_tensorObj` honestly.
2. **Consider the USER-directed `PicGroup.lean` file split** now that the group landed (USER directive
   #2 per the prover handoff) — TensorObjSubstrate.lean is 901 lines and §5 could move to its own file.
3. The two deferred dual-bridge sorries (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`)
   remain open by design; they are downstream of the group law, not blockers to it.

## MAJOR — documentation rot (both reviewers; act next iter, not blocking)
The associator's iter-237/238 route change (flatness route → route-(d), then hyp-drop) left stale
descriptions in BOTH the Lean comments and the blueprint prose. These actively misinform readers about
the sorry-debt status of a now-axiom-clean, load-bearing declaration. **Neither is in the review agent's
write domain** (Lean comments = prover/refactor; blueprint informal prose = plan agent / blueprint-writer):

- **Lean side (`lean-auditor` ts238 — 4 major, all stale comments):**
  - `TensorObjSubstrate.lean:302–340` — `tensorObj_assoc_iso` docstring still describes the OLD
    flatness-based argument ("`W_whiskerLeft/Right_of_flat`… sectionwise flatness… invertible ⇒ flat")
    and claims sorry-transitivity through `isLocallyInjective_whiskerLeft_of_W`. The actual body uses
    `W_whiskerRight_of_W`/`W_whiskerLeft_of_W` (no flatness); axiom check confirms clean. **Rewrite the
    docstring to the route-(d) reality.**
  - `TensorObjSubstrate.lean:43–45` — module-header "Status" section lists `isLocallyInjective_whiskerLeft_of_W`
    as a remaining residual and omits the newly-landed §5 (`picCommGroup` etc.). **Refresh.**
  - `TensorObjSubstrate.lean:730 vs 865` — **section ordering disorder**: §5 (L730) appears BEFORE §4
    (L865); file reads §1→§2→§3→§5→§4. Consider renumbering / reordering in a refactor pass.
  - L57–87, L98–112 — "3 blueprint-pinned declarations" / sub-module layout comments don't mention §5.
  → Direct a prover (or a `refactor` subagent) to do a one-pass comment cleanup of TensorObjSubstrate.lean.

- **Blueprint side (`lean-vs-blueprint-checker` ts238 — 2 major, 2 minor):**
  - **(major)** `Picard_TensorObjSubstrate.tex` L1452–1456: stale note claims the Lean pin "additionally
    carries locally trivial (`LineBundle.IsLocallyTrivial`) hypotheses on M,N,P." **False after iter-238**
    — they were dropped. Replace with "The Lean pin is unconditional (iter-238); no local-triviality
    hypothesis is present."
  - **(major)** `lem:tensorobj_assoc_iso` title "Associator for ⊗_X on **locally trivial objects**" →
    retitle "(unconditional)".
  - **(minor)** Remove stale `\uses{lem:tensorobj_restrict_iso}` from `lem:tensorobj_assoc_iso` (route-(d)
    does not consume it).
  - **(minor)** `\uses` of `lem:isinvertible_inverse_welldef` cites `lem:tensorobj_assoc_iso_invertible`;
    the Lean uses the stronger `tensorObj_assoc_iso` directly — repoint or keep (subsumed; harmless).
  → Dispatch a `blueprint-writer` on `Picard_TensorObjSubstrate.tex` next iter for items 1–4.

## HIGH — structural: blueprint-doctor broken cross-ref (sync_leanok artifact)
`Cohomology_FlatBaseChange.tex` L350–352: `sync_leanok` injected a `\leanok` **inside** the multi-line
`\uses{...}` braces, so the doctor reads `\uses{\leanok lem:fromTildeGamma_app_isIso_of_localized}` as a
broken cross-ref (the label itself EXISTS at L302). The dependency graph will draw a missing edge.
**Fix:** relocate the `\leanok` out of the `\uses{}` list to its own line (identical to the repair the
iter-238 plan agent did for `lem:W_implies_stalkwise_iso` in TensorObjSubstrate.tex). Left for the next
plan agent — `\leanok` relocation is outside the review agent's marker domain. No active prover is blocked.

## Engine lane — FlatBaseChange (STUCK, corrective applied iter-238)
Per the iter-238 plan, the FlatBaseChange prover slot was correctly swapped for a blueprint-writer
expansion (the element-free `D(a)`-transport recipe, writer `fbcdax`). The lane re-engages NEXT iter on
the now-fully-specified `affineBaseChange_pushforward_iso` close. **Do NOT verbatim-re-dispatch** without
the expanded chapter clearing the blueprint-reviewer gate. Reversing signal (from the planner): if the
prover, on the fully-specified `D(a)` recipe, STILL cannot build `e_{D(a)}` (a 4th smul-wall location),
the `smul`-through-global-ring shape of `modulesSpecToSheaf` is the structural bug → mathlib-analogist
(cross-domain) on the `R`-action-on-pushforward-sections design.

## Reusable proof patterns discovered this iter
- **Namespace shadowing inside `Foo.bar`-named decls:** inside a decl named `IsInvertible.tensorObj`,
  bare `tensorObj` resolves to the decl itself (the `IsInvertible` namespace is in scope while
  elaborating). Fully-qualify (`Scheme.Modules.tensorObj`) in statement + body. Dot-notation
  (`hM.tensorObj hM'`) elsewhere is unaffected.
- **Class-type `def` → `instance`:** a `def` whose type is a class (`CommGroup …`) trips the
  reducible-class linter; declare it `instance` (when no competing instance exists, no diamond).
- **Quotient group law with no monoidal coherence:** every `CommGroup` field over a `Quotient` of
  iso-classes reduces by `Quotient.ind` + a single `Quotient.sound ⟨…iso…⟩`; `Quotient.sound` passes
  through `Quotient.lift₂`/`lift` definitionally (no `simp`). No pentagon/triangle/hexagon needed —
  group axioms are *existence* of isos, not coherence of a chosen one.
- **Inverse via membership witness:** `IsInvertible M := ∃ N, M ⊗ N ≅ 𝒪` lets `inv` be
  `Classical.choose`; well-definedness is `IsInvertible.inverse_unique` (Stacks 0B8M carrier pivot).

## Blueprint markers updated by the review agent this iter
- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation_naturality_right`: removed the dangling
  `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` pin (decl never created; inlined into
  `isLocallyInjective_whiskerLeft_of_W`). `\label` retained (consumed by `\uses`/`\cref` at L2235/L2250);
  `% NOTE:` updated to record the removal. Resolves the planner's iter-238 "soon" review-agent item.
