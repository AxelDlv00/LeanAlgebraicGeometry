# Blueprint Writer Report

## Slug
quot-annihilator

## Status
COMPLETE — all three directive tasks landed; `leandag` reports `isolated: 0`, `unknown_uses: []`, `conflicts: []`.

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made
- **Added lemma** `\begin{lemma}`/`\label{lem:annihilator_localization_eq_map}`/`\lean{Module.annihilator_isLocalizedModule_eq_map}` (Task 1) — the algebra engine: for a **finitely generated** \(R\)-module \(M\) and a localization \(f : M \to M_S\) exhibiting \(M_S\) as \(S^{-1}M\), \(\mathrm{Ann}_{R_S}(M_S) = (\mathrm{Ann}_R M)\cdot R_S = \mathrm{map}(R\to R_S)(\mathrm{Ann}_R M)\). The finite-generation hypothesis is stated as essential.
  - Proof sketch added: Y — `⊇` annihilator elements map forward; `⊆` clear a single common denominator `u = ∏ uᵢ` over the finitely many generators (the step that needs finiteness). Mirrors the directive's sketch.
  - This matched the real landed Lean decl (`leandag` did NOT list it as unmatched → it is proved).
- **Added Mathlib anchor** `\begin{lemma}`/`\label{lem:isLocalization_basicOpen_mathlib}`/`\lean{AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen}`/`\mathlibok` — \(\Gamma(X,D(f)) = (\Gamma(X,U))_f\) (`IsLocalization.Away f`) on an affine open. Verified the declaration exists in Mathlib (`AlgebraicGeometry/AffineScheme.lean:650`, namespace `AlgebraicGeometry.IsAffineOpen`) before marking `\mathlibok`.
- **Added lemma** `\begin{lemma}`/`\label{lem:qcoh_section_localization_basicOpen}`/`\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (Task 2) — the MISSING QCoh → IsLocalizedModule bridge: for quasi-coherent finite-type \(\mathcal{M}\), affine open \(U\), \(f\in\Gamma(X,U)\): (1) \(\Gamma(X,D(f))=(\Gamma(X,U))_f\); (2) the restriction \(\mathcal{M}(U)\to\mathcal{M}(D(f))\) is a localized module at `powers f`. The Lean name is a TODO the prover will create (shows as `unmatched_lean`, as intended).
  - Proof sketch added: Y — identify \(U\cong\Spec\Gamma(X,U)\), \(\mathcal{M}|_U = \widetilde{N}\) with \(N=\mathcal{M}(U)\) finite, use the Spec-local \(\Gamma(D(f),\widetilde N)=N_f\), transport across the affine identification. Flagged the transport as the substantive content.
- **Revised** `def:modules_annihilator` (Task 3) — (a) added `\uses{lem:annihilator_localization_eq_map, lem:qcoh_section_localization_basicOpen}`; (b) changed the hypothesis from "coherent sheaf" to "quasi-coherent and of finite type (so \(\mathcal{F}(U)\) is a finite \(\Gamma(X,U)\)-module)"; (c) added a "Well-definedness on basic opens" paragraph spelling out the `map_ideal_basicOpen` coherence and how the two new lemmas discharge it, including that finite-type is genuinely required. Kept the `% NOTE (iter-007)` comment and the existing Nitsure `% SOURCE QUOTE` untouched.

## Cross-references introduced
- `def:modules_annihilator` `\uses{lem:annihilator_localization_eq_map, lem:qcoh_section_localization_basicOpen}` — both targets are in this same chapter (new blocks above).
- `lem:annihilator_localization_eq_map` `\uses{def:modules_annihilator}` — per directive (see note below); target in this chapter.
- `lem:qcoh_section_localization_basicOpen` `\uses{lem:isLocalization_basicOpen_mathlib}` (statement + proof) — target in this chapter (the new Mathlib anchor).
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`, `isolated: 0`. No broken or dangling edges introduced.

## References consulted
- `references/stacks-schemes.tex` (L593–722, esp. Lemma `lemma-spec-sheaves` item (4), L691–702) — verbatim `% SOURCE QUOTE` for `lem:qcoh_section_localization_basicOpen` part (2): "For every \(f\in R\) we have \(\Gamma(D(f),\widetilde M)=M_f\) as an \(R_f\)-module."
- `references/stacks-schemes.md` — pointer/contents map for the Schemes chapter; used to confirm §7 "Quasi-coherent sheaves on affines" location (the `.md` pointer maps tag 01I9 to a *different* lemma `lemma-widetilde-pullback`, so I cited `lemma-spec-sheaves` by its label + line numbers rather than guessing its tag — see Notes).
- `references/summary.md` — reference index.
- Mathlib source (not under `references/`, for `\lean{}`/`\mathlibok` verification only): `AlgebraicGeometry/AffineScheme.lean:650` (`isLocalization_basicOpen`); `AlgebraicJacobian/Picard/QuotScheme.lean:289` (`Module.annihilator_isLocalizedModule_eq_map`, confirming the Task 1 signature/hypotheses).

## Macros needed (if any)
- None. All commands used (`\Spec`, `\cref`, `\mathrm`, etc.) are already in use elsewhere in the chapter / `macros/common.tex`.

## Reference-retriever dispatches (if any)
- None. The directive-named source (Stacks tag 01I9 widetilde / the `\widetilde M` basic-open fact) was already present in `references/stacks-schemes.tex`; the verbatim statement I needed is in the adjacent `lemma-spec-sheaves` item (4), which I read and quoted directly.

## Notes for Plan Agent
- **Mutual edge between `def:modules_annihilator` and `lem:annihilator_localization_eq_map`.** The directive specified BOTH directions: Task 1 gives the engine lemma `\uses{def:modules_annihilator}`, and Task 3 gives the definition `\uses{lem:annihilator_localization_eq_map}`. I implemented both as instructed. `leandag` reported `conflicts: []` (it did not flag this as a cycle), so no graph error. Mathematically the load-bearing edge is `def → lem` (the definition's well-definedness consumes the pure-algebra lemma); the reverse `lem → def` is not a mathematical dependency (the engine lemma is plain commutative algebra and does not reference the sheaf annihilator). If you prefer a strictly acyclic graph, dropping the `\uses{def:modules_annihilator}` line from the lemma would leave it still connected (the definition still uses it) — flagging for your call; I left it per the directive.
- **Stacks tag for the cited lemma.** The local pointer `references/stacks-schemes.md` only records tag **01I9** for `lemma-widetilde-pullback` (pullback of \(\widetilde M\)). The statement I actually needed (basic-open sections = \(M_f\)) lives in the adjacent `lemma-spec-sheaves`. I did not have its Stacks tag in any opened file, so to avoid citing a tag from memory I cited it by chapter (tag 020J), section (§7), the lemma's label `lemma-spec-sheaves`, item (4), and the exact line range I read. If you want a tag-precise citation, a retriever could confirm the `lemma-spec-sheaves` tag (it is the standard "Spec sheaves" summary lemma).
- **Prover target ready.** `lem:qcoh_section_localization_basicOpen` is now blueprinted with the exact TODO Lean name `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`; together with the proved `Module.annihilator_isLocalizedModule_eq_map` and the Mathlib `isLocalization_basicOpen`, a `mathlib-build` prover has a complete spec to close `def:modules_annihilator`'s `map_ideal_basicOpen` coherence next iter.

## Strategy-modifying findings
None. Writing the blocks confirmed the strategy's stated plan (algebra engine already landed + a single QCoh→IsLocalizedModule bridge unblocks the annihilator); no strategy-level contradiction surfaced. The finite-type hypothesis the directive flagged is correctly load-bearing and is now explicit in both the definition's prose and the engine lemma's statement.
