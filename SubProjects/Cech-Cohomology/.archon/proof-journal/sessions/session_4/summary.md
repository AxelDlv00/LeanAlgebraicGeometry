# Session 4 (iter-004) — review summary

## Metadata
- **Iteration / session**: iter-004 / session_4
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`, `[prover-mode: mathlib-build]`). Model: sonnet.
- **Global sorry count**: 2 → 2 (unchanged). Remaining sorries both in `CechHigherDirectImage.lean`: `CechAcyclic.affine` (L774), `cech_computes_higherDirectImage` (L811) — P3/P5, intentionally out of scope this iter.
- **`AcyclicResolution.lean`**: 0 → 0 sorries (`mathlib-build` adds *new* sorry-free declarations; does not touch existing sorries).
- **Declarations added: 5**, all verified axiom-clean (`{propext, Classical.choice, Quot.sound}`).
- **Named blueprint targets completed: 0 of 3** (horseshoe / object-level shift / staircase all remain).

## What the prover did (P4 lane: Stacks 015E, acyclic resolution computes R^nG)

The lane is a single bottom-up chain: horseshoe → dimension-shift → staircase. This session built
**every piece that *consumes* the horseshoe** and verified all Mathlib inputs are present, collapsing
the whole lane to one remaining construction. The five new declarations (all RESOLVED, axiom-clean):

1. `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic` (L108) — `Hᵏ⁺¹(G(I_J))=0` for
   acyclic `J`, by transporting `IsRightAcyclic.vanish` across `isoRightDerivedObj`. Kills the middle
   terms feeding `δIso`.
2. `shortExact_of_degreewise_splitting` (L121) — degreewise `ShortComplex.Splitting` ⇒ complex-level
   `ShortExact`. Wrapper over `HomologicalComplex.shortExact_of_degreewise_shortExact`.
3. `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` (L133) — additive `G` preserves a
   degreewise-*split* SES of complexes. Key defeq: `G.mapHomologicalComplex c ⋙ eval n = eval n ⋙ G`.
4. `Functor.rightDerivedShiftIsoOfSplitResolutionSES` (L153) — **the dimension-shift engine**, at the
   resolution level. Given the horseshoe SES *as a hypothesis* (chain maps `φ,ψ`, degreewise `splits`,
   acyclic middle `J`), produces `(R^{k+1}G)(Z) ≅ (R^{k+2}G)(A)` as a 3-step `Iso.trans`:
   `isoRightDerivedObj(Z) ≪≫ δIso ≪≫ isoRightDerivedObj(A).symm`.
5. `mono_biprod_lift_factorThru_of_exact` (L181) — the per-stage horseshoe monomorphism
   `B ↪ I_A^{n+1} ⊞ I_C^{n+1}`. Needs only `Exact + Mono S.f` (epi unused), so it applies verbatim to
   every cosyzygy stage.

### Key finding — the dimension shift is far cheaper than the strategy feared
The strategy (STRATEGY.md / iter-002–003) treated the SES→LES propagation for `rightDerived` as a
to-build kernel requiring a hand-rolled long-exact-sequence chase. In fact Mathlib's
`ShortComplex.ShortExact.δIso` (`Mathlib/Algebra/Homology/HomologySequence.lean:355`) yields the
connecting iso `Hⁱ(X₃) ≅ Hʲ(X₁)` *directly* from `IsZero` of the middle homology in the two adjacent
degrees. Combined with `isoRightDerivedObj`, the entire dimension shift is a three-step `Iso.trans` —
no LES chase, no horseshoe needed for *this* step. This is a reusable pattern (see Knowledge Base).

### Why the prover stopped
The sole adjacent declaration left is the horseshoe object `InjectiveResolution.ofShortExact` itself:
a monolithic ℕ-recursion building `I_B.cocomplex` with twisted differential `[[d_A,τ],[0,d_C]]` plus a
proof that `I_B` resolves `B`. `mathlib-build` permits no `sorry`, and there is no smaller
self-contained axiom-clean fragment beyond decl #5 (already landed). The informal-agent fallback was
unavailable (only `GEMINI_CLI_*` in env, which `archon-informal-agent.py` does not consume).

## HEADLINE FINDING — false `\leanok` on the horseshoe (DAG poisoning)

`lem:injective_resolution_of_ses` (the horseshoe, `\lean{CategoryTheory.InjectiveResolution.ofShortExact}`)
carries `\leanok` on **both** its statement block (chapter L190) and its proof block (chapter L217),
but **`InjectiveResolution.ofShortExact` does not exist as a Lean declaration** (`lean_verify`:
"Unknown constant"). Confirmed first-hand and independently by the lean-vs-blueprint-checker.

**Root cause**: the `/-! ... -/` strategy comment in `AcyclicResolution.lean` (lines ~230–347) contains
a ``` ```-fenced "Output type (suggested)" snippet whose first line is, literally,
`def InjectiveResolution.ofShortExact {A B C : 𝒜} (ses : ShortComplex 𝒜)` (file L283). The
`sync_leanok` declaration matcher (and the LSP outline) read that fenced text as a real, sorry-free
declaration and stamped `\leanok`. `sync_leanok-state.json` for iter-004 records `added: 3, removed: 0`
on exactly this chapter — almost certainly `def:right_acyclic` (genuine) + the two false markers above.

**Why it matters**: the horseshoe is the *sole remaining P4 blocker*. A false "done" on it tells the
DAG/planner the hardest piece is built, risking the planner never dispatching a prover to construct it.
This is a structural false-done, not a cosmetic marker slip.

**Remediation** (I cannot touch `\leanok` — owned by `sync_leanok` — nor edit `.lean`): I added a
`% NOTE:` to the block (chapter L190) documenting the false marker and the fix. The actual fix is
Lean-side and belongs to the next plan iter: reformat the code fence in the strategy comment (prose or
`--` prefix) so the matcher stops matching; `sync_leanok` then strips both `\leanok` automatically.
See `recommendations.md` (top) and `task_results/lean-vs-blueprint-checker-acyclic.md`.

## Subagent dispatches
- **lean-auditor** (`iter004`): dispatched (a `.lean` file was modified this iter). Verdict: clean —
  0 critical / 0 major / 3 minor. Confirmed all 5 new decls sorry-free, axiom-clean, and **not
  vacuous** (`rightDerivedShiftIsoOfSplitResolutionSES` genuinely consumes `[IsRightAcyclic J]` and
  `splits`; removing either breaks the body). Confirmed the `def ...ofShortExact` at L283 is inert
  (inside a code fence). Report: `task_results/lean-auditor-iter004.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched (file received prover work). Verdict: 3
  must-fix-this-iter (the false-`\leanok` root cause, above), 2 major (substantive new decls lacking
  `\lean{}` tags — see recommendations). Report: `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint doctor
No structural findings (`logs/iter-004/blueprint-doctor.md`): every chapter `\input`'d, every
`\ref`/`\uses` resolves, no `axiom` declarations. The false-`\leanok` is a marker-truth issue the
doctor does not check; surfaced here and in recommendations instead.

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:injective_resolution_of_ses`: added `% NOTE:` flagging that
  the `\leanok` (statement + proof) are false-done markers — `InjectiveResolution.ofShortExact` does
  not exist; root cause is the code-fence in the `.lean` strategy comment; fix is Lean-side. (No
  `\leanok` touched — out of review domain.)
- No `\mathlibok` added: the 5 new decls are project proofs (`lean_aux`), not Mathlib re-exports; the
  chapter's four Mathlib anchors already carry correct `\mathlibok`.
- No `\lean{...}` corrections applied: the divergence between `\lean{rightDerivedShiftIsoOfAcyclic}` and
  the actually-built `rightDerivedShiftIsoOfSplitResolutionSES` is forward-pointing (the object-level
  target is still to be built), not a rename — recorded for the planner instead (see recommendations).

## Notes (LOW)
- lean-auditor minor items: docstring of decl #4 says it takes an object-level SES as hypothesis when
  the decl is actually more general (resolution-level); the suggested-signature comment has dead
  `{A B C : 𝒜}` implicits; two >100-char lines on comment lines 322/346. All comment-only, non-blocking.
