# Refactor Directive

## Slug
cotangent-grpobj-docstring-refresh-iter133

## Problem

The iter-132 prover lane closed `cotangentSpaceAtIdentity_finrank_eq` at line 244 of `AlgebraicJacobian/Cotangent/GrpObj.lean`. However, **all 5 docstring sites in the file that mention the rank lemma were authored under the iter-130/iter-131 assumption that the rank lemma would live in a *follow-up* declaration (a different file or a later iter)**. With the iter-132 in-file addition, these docstring claims are now factually wrong and misleading on quick read.

Per `lean-auditor-review132` (5 major findings, all stale-framing — no must-fix; pure documentation hygiene):

- **File-level header lines 28–30** — "The companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (rank = relative dimension `n` from `[SmoothOfRelativeDimension n G.hom]`) is deferred to iter-132+ for blueprint-RHS-pinning work; not in this file." — STALE: the named theorem is at line 244 of the very same file.
- **`## Status` block lines 32–57** — frames file state as iter-131 closure with only `cotangentSpaceAtIdentity` + `_eq_extendScalars`; does not mention iter-132's rank theorem; contradicts the actual file state.
- **`cotangentSpaceAtIdentity` declaration docstring lines 96–99** — "the iter-132+ companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (in a follow-up declaration) pins the rank to `n`" — the parenthetical is now false.
- **`cotangentSpaceAtIdentity` declaration docstring lines 136–138** — "the iter-132+ rank lemma can rewrite against" should be past tense; the rank lemma at line 244 already does so.
- **`cotangentSpaceAtIdentity` declaration docstring lines 144–148** — lumps `rank = n` with `Module.Free k` / `Module.Finite k` as "iter-132+ content for the rank lemma"; the `rank = n` half is now closed; `Module.Free k` / `Module.Finite k` remain genuine future work (out of scope this iter).

Additionally, the **iter-132 lean-vs-blueprint-checker** flagged 1 minor on the style side:
- `lines 252–254` of the rank-lemma proof: `set U := h.choose with hU_def`, `set V := … with hV_def`, `set e := … with he_def` introduce hypothesis names that are never consumed in the proof body. The `with` clauses can be dropped, or `let` used instead.

Optional bundling (per HIGH-A + MED-D of `recommendations.md`): roll the style nit on `set ... with _def` into this refactor lane.

## Mathematical Justification

This is a pure documentation refresh. The semantics of the file (definitions, signatures, theorem statements, proof bodies, axioms) is unchanged. The only edits are to:

1. **File-level header (lines 28–30)** — replace the future-tense "deferred to iter-132+; not in this file" with present-tense reality: the rank lemma is closed in this file at the bottom; this file contains the definition + a strong acceptance lemma + the rank lemma.

2. **`## Status` block (lines 32–57)** — extend the status narrative to acknowledge the iter-132 close. Suggested append (preserving the iter-130 / iter-131 history): "Iter-132 prover lane closed the companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` (line 244) against the iter-131 body via parallel `Classical.choose`-chain extraction on `Scheme.smooth_locally_free_omega`, reducing through `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`."

3. **`cotangentSpaceAtIdentity` declaration docstring (lines 96–99)** — change "(in a follow-up declaration)" parenthetical to "(at line 244 below)".

4. **`cotangentSpaceAtIdentity` declaration docstring (lines 136–138)** — change future-tense "the iter-132+ rank lemma can rewrite against" to "the iter-132 rank lemma `cotangentSpaceAtIdentity_finrank_eq` (line 244 below) rewrites against".

5. **`cotangentSpaceAtIdentity` declaration docstring (lines 144–148)** — split the `Module.Free k` / `Module.Finite k` / `rank = n` enumeration so the `rank = n` half is correctly attributed to the closed iter-132 lemma, while `Module.Free k` and `Module.Finite k` remain flagged as deferred follow-ups (genuine future work; not closed yet).

6. **Optional style nit (lines 252–254 of the rank-lemma proof)** — drop the `with hU_def`, `with hV_def`, `with he_def` clauses since the introduced hypothesis names are never consumed. Either:
   - (a) Drop the `with` clauses: `set U : (Spec (.of k)).Opens := h.choose`, etc. — keeps the `set` semantics but removes the unused names.
   - (b) Replace `set` with `let`: `let U : (Spec (.of k)).Opens := h.choose`, etc. — both options preserve proof correctness; (b) more closely mirrors the body's style. Choose (b) for consistency with the body's `let`-chain.

All 6 edits are docstring/style only; no theorem statements change.

## Changes Requested

- File: `AlgebraicJacobian/Cotangent/GrpObj.lean`
  - **Edit 1**: File-level header (around lines 28–30): replace `"deferred to iter-132+ for blueprint-RHS-pinning work; not in this file."` with present-tense narrative pointing at line 244 as the iter-132 close site. The new wording should describe what this file *contains* (definition + strong acceptance lemma + rank lemma), not what's deferred elsewhere.
  - **Edit 2**: `## Status` block (around lines 32–57): retitle to `## Status (iter-132 close: rank lemma)` and extend the narrative chain (iter-130 body swap → iter-131 body shape refactor + acceptance lemma → iter-132 rank-lemma close via parallel `Classical.choose`-chain extraction). Preserve the iter-131 description; just append the iter-132 paragraph.
  - **Edit 3**: `cotangentSpaceAtIdentity` declaration docstring (around lines 96–99): change `(in a follow-up declaration)` → `(at line 244 below)`.
  - **Edit 4**: `cotangentSpaceAtIdentity` declaration docstring (around lines 136–138): change `the iter-132+ rank lemma can rewrite against` → `the iter-132 rank lemma 'cotangentSpaceAtIdentity_finrank_eq' (line 244 below) rewrites against`.
  - **Edit 5**: `cotangentSpaceAtIdentity` declaration docstring (around lines 144–148): split the enumeration. New wording should be:
    `"The rank (= n) is now pinned by 'cotangentSpaceAtIdentity_finrank_eq' (line 244 below; closed iter-132). The free/finite structural properties ('Module.Free k', 'Module.Finite k') are content for follow-up companion lemmas (not yet in this file); the structural-shape accessibility needed by those lemmas is witnessed here by 'cotangentSpaceAtIdentity_eq_extendScalars' (line 198 below)."`
  - **Edit 6** (optional style nit): rank-lemma proof body (around lines 252–254): replace `set U := h.choose with hU_def`, `set V := h.choose_spec.choose with hV_def`, `set e := ... with he_def` by either:
    - dropping the `with ..._def` clauses (`set U : (Spec (.of k)).Opens := h.choose`), OR
    - replacing `set` with `let` (`let U : (Spec (.of k)).Opens := h.choose`).
    Refactor agent: please use the `let` form to match the body's style (`let h := Scheme.smooth_locally_free_omega ...` etc.). Verify the proof still closes after the change (it should, since `hU_def`/`hV_def`/`he_def` are not consumed downstream).

## Affected Files

- `AlgebraicJacobian/Cotangent/GrpObj.lean` (the only file modified; pure docstring + 1 style change).

No imports / cascading breakage. Verify `lean_diagnostic_messages` on the file returns `[]` after edits.

## Expected Outcome

- File compiles cleanly with `lean_diagnostic_messages` returning `[]`.
- `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` returns kernel-only axioms `{propext, Classical.choice, Quot.sound}` (unchanged from iter-132 close).
- Sorry count: 0 (unchanged).
- File LOC: minor change only (~5–15 LOC of docstring shift; +/- 0–5 net depending on whether status block grows or stays put).
- No `archon-protected.yaml` edits.

## Constraints

- **Do NOT edit any other `.lean` file.** Only `AlgebraicJacobian/Cotangent/GrpObj.lean`.
- **Do NOT change any theorem statement, definition body, or proof body** (only docstrings + optionally the `set`/`let` style nit).
- **Do NOT add or remove `\notready` / `\leanok` markers in blueprint chapters.** Those are managed by `sync_leanok` / review agent.
- **Do NOT add any new declarations** (no companion `Module.Free k cotangentSpaceAtIdentity` lemma, etc. — those are future work and out of scope this iter).
- **Preserve all `Authors:` and copyright header lines** (line 1–5).

Report to `task_results/refactor-cotangent-grpobj-docstring-refresh-iter133.md` per `.archon/subagents/refactor.md` rules.
