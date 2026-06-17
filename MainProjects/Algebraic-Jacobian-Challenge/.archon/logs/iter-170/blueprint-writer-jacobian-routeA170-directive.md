# Blueprint-Writer Directive — Slug `jacobian-routeA170`

## Chapter

`blueprint/src/chapters/Jacobian.tex`

## Strategy context (the slice that matters for this chapter)

Route A — Picard scheme via FGA — is the COMMITTED path for the positive-genus object `J = Pic⁰_{C/k}`. STRATEGY.md row 1 budgets it at `~5100+ LOC · 0/it`, `~40-70 iters left`, and notes "A.2 representability is the riskiest, least-Mathlib piece". The strategy-critic (`routefork170`, iter-170) flagged that Route A's `~5100+ LOC · 0/it · ~40-70 iters` deferral is the largest single-line deferral in the strategy. The chapter currently has A.1–A.4 sub-phase PROSE (Jacobian.tex `\paragraph{Route A — Picard scheme.}` L316–L345 = the 4-step decomposition; L484–L515 = the positive-genus arm theorem block with cross-references to Route A) but does NOT have per-sub-phase LOC + iter estimates, nor a Mathlib-prerequisite cascade list.

The genus-0 arm is being prosecuted in parallel on a different file (`AbelianVarietyRigidity.lean` + `Genus0BaseObjects.lean`); Route A is file-disjoint from the genus-0 prover lane this iter, which is why the strategy-critic instructed the planner to schedule Route A blueprint decomposition in parallel rather than serialize behind the genus-0 stall.

## Required edits

### Edit 1 — Add per-sub-phase LOC + iter estimates to A.1–A.4 (REQUIRED)

Inside the `\paragraph{Route A --- Picard scheme.}` block (currently at L316–L345), after the closing `\end{itemize}` of the Mathlib-status block (L344) and before the `\paragraph{Route B}` line (L347), insert a new paragraph:

```latex
\paragraph{Route A --- per-sub-phase LOC and iter budget.}

The Route A build-out breaks into four sub-phases with the following cost
estimates (LOC = lines of Lean to land axiom-clean; iters = prover iterations
at the project's current ~80-100 net-LOC-per-iter velocity on infrastructure
material). The Mathlib-prerequisite cascade for each sub-phase is also
recorded so subsequent planner decisions can sequence the upstream pieces.

\begin{itemize}
  \item[(A.1)] \emph{Relative Picard functor + relative-line-bundles theory.}
    Net new project material: ~700–1100 LOC. Iters: ~6–10. The smallest
    standalone Mathlib entry point is the \texttt{RelativeSpec} functor
    (per the iter-123 audit \texttt{analogies/m3-route-audit.md}); the rest
    is line-bundle / $\Pic$ machinery on a product $C \times_k T$, which
    Mathlib has only partially in the form needed.
  \item[(A.2)] \emph{Hilbert / Quot scheme representability + FGA
    representability of $\Pic_{C/k}$.} Net new project material:
    ~2200–3000 LOC. Iters: ~15–25. The dominant cost. The Quot/Hilbert
    construction engine is Nitsure §4–5 (\texttt{references/nitsure-hilbert-quot.md});
    the cohomology-and-base-change layer underneath is Stacks tag 02KH
    (\texttt{references/stacks-coherent.md}). The étale-sheafification step
    when $k$ is not algebraically closed adds ~200 LOC and requires
    Mathlib's étale-sheafification machinery (verified present:
    \texttt{Mathlib/CategoryTheory/Sites/Pushforward.lean} family).
  \item[(A.3)] \emph{Identity component $\Pic^0_{C/k}$ + degree map.}
    Net new project material: ~600–900 LOC. Iters: ~5–8. Connectedness
    machinery for group schemes locally of finite type; the identity
    component construction $G^0 \subseteq G$; the degree map
    $\Pic_{C/k} \to \underline{\mathbb Z}_k$ via the locally-constant
    pushforward (cf. \texttt{references/stacks-coherent.md}, base change of
    $R^i f_*$). Smoothness via the deformation-theoretic identification of
    the tangent space with $H^1(C, \mathcal O_C)$ uses the cohomology
    layer of (A.2).
  \item[(A.4)] \emph{Albanese universal property of $\Pic^0_{C/k}$.}
    Net new project material: ~900–1200 LOC. Iters: ~7–11. Milne
    Proposition~6.1 / 6.4 (\texttt{references/abelian-varieties.pdf}). Reuses
    the proven Rigidity Lemma + Cor 1.2 + Cor 1.5 from the genus-0 stack
    (already in tree, axiom-clean per iter-162); the remaining work is
    Picard-functor functoriality + the seesaw / Albanese-UP arguments
    Milne~§III.6 covers in ~3 pages. Char-free.
\end{itemize}

Total Route A budget: ~4400–6200 LOC; ~33–54 iters. The STRATEGY.md
\texttt{Iters left}: \texttt{~40-70} envelope is preserved on the upper end
when serialization losses + Mathlib-API friction are folded in; the lower
end is plausible only if (A.2)'s Quot/Hilbert build-out lands cleanly.

\paragraph{Mathlib-prerequisite cascade for Route A.}

The work landings can be partially serialised because each sub-phase has a
prerequisite tail rooted in a different Mathlib namespace:

\begin{itemize}
  \item (A.1) → \texttt{Mathlib.AlgebraicGeometry.RelativeSpec},
    \texttt{Mathlib.AlgebraicGeometry.LineBundle.Pullback},
    \texttt{Mathlib.CategoryTheory.Sites.Pullback}.
  \item (A.2) → \texttt{Mathlib.AlgebraicGeometry.HilbertScheme} (absent),
    \texttt{Mathlib.AlgebraicGeometry.QuotScheme} (absent),
    \texttt{Mathlib.AlgebraicGeometry.Cohomology.BaseChange} (Stacks 02KH;
    partially in Mathlib).
  \item (A.3) → \texttt{Mathlib.AlgebraicGeometry.GroupScheme.IdentityComponent},
    \texttt{Mathlib.AlgebraicGeometry.LocallyConstantPushforward}.
  \item (A.4) → no new Mathlib namespace; reuses
    \texttt{AlgebraicJacobian.AbelianVarietyRigidity} (in tree, axiom-clean)
    + Mathlib's Albanese-style universal property machinery.
\end{itemize}

The dominant block is (A.2). It can be started in parallel with the
genus-0 stack because it is file-disjoint and its prerequisites are
Mathlib-side rather than project-side.
```

### Edit 2 — Refresh the existing "Mathlib status" bullets to point at the per-sub-phase budget (REQUIRED)

Inside the existing `\emph{Mathlib status for Route A.}` block (L339–L345), append a one-liner to each of the four bullets indicating the LOC + iter slice. For example, the A.2 bullet (currently "Sub-step A.2 requires FGA representability for $\Pic_{C/k}$..." at L342) should end with "(See per-sub-phase budget below: ~2200–3000 LOC, ~15–25 iters.)". Do this for each of (A.1)/(A.2)/(A.3)/(A.4). Minimal text change; keeps the existing prose intact.

### Edit 3 — Reference the per-sub-phase budget from `thm:positiveGenusWitness` (L489 region) (REQUIRED)

Inside the positive-genus-arm theorem block (around L502–L515, currently saying "$\sim 6500$ LOC midpoint per the iter-123 audit"), update the LOC figure to reference the new per-sub-phase budget. Specifically, replace "$\sim 6500$ LOC midpoint per the iter-123 audit \texttt{analogies/m3-route-audit.md}" with "Per-sub-phase budget recorded in the new \emph{Route A --- per-sub-phase LOC and iter budget} paragraph above ($\sim 4400$–$6200$ LOC total, $\sim 33$–$54$ iters; was $\sim 6500$ midpoint per the iter-123 audit \texttt{analogies/m3-route-audit.md} — the refresh narrows the range and breaks out the dominant (A.2) block at $\sim 2200$–$3000$ LOC)".

## What you MUST NOT do

- Do NOT add or remove `\leanok` / `\mathlibok` markers. The sync_leanok phase handles `\leanok`; review handles `\mathlibok`.
- Do NOT modify any other chapter file.
- Do NOT edit the genus-0 sub-case content (L376+) or the C.2 / C.2.a–f sub-blocks — those are the genus-0 arm and are being prosecuted on the upstream `AbelianVarietyRigidity.tex` chapter. Route A only.
- Do NOT touch Route B prose (L347–L374) — it's the historical alternative, "not pursued"; the strategy-critic flagged that retention is appropriate.
- Do NOT spawn child subagents. No external sources are needed beyond the references already listed (Nitsure, Stacks 02KH, Milne, Kleiman); read them ONLY if a fact in your edits needs verification.

## Citation discipline

When adding the Mathlib-prerequisite cascade bullets, you may cite Mathlib file paths verbatim from your read of the codebase ONLY for files you can verify exist. Use Bash / Grep to verify, e.g. `Mathlib/CategoryTheory/Sites/Pullback.lean` — if it doesn't exist, mark the prerequisite as `\texttt{[not yet in Mathlib]}` rather than fabricating a path. The cascade bullets that name absent Mathlib pieces (e.g. `Mathlib.AlgebraicGeometry.HilbertScheme` (absent)) should retain the `(absent)` tag; verify the absent claim via Glob/Grep.

References in tree:
- `references/nitsure-hilbert-quot.md` and `references/nitsure-hilbert-quot.pdf`
- `references/kleiman-picard.md` and `references/kleiman-picard.pdf`
- `references/stacks-coherent.md` (tag 02KH)
- `references/abelian-varieties.pdf` (Milne; §III.6 Albanese UP)
- `analogies/m3-route-audit.md` (iter-123 cost audit — still load-bearing)

## Output

Report at `task_results/blueprint-writer-jacobian-routeA170.md`. Cite the line numbers post-edit so the next iter's lean-vs-blueprint-checker can re-verify, and report whether `analogies/m3-route-audit.md` needs an iter-170 refresh ENTRY (it does NOT need rewriting; just note in your report if your numbers diverge significantly from the iter-123 audit).

## Strategy-modifying findings

If during the writing you discover that a sub-phase number is materially different from the per-sub-phase estimates above (>30% divergence on the LOC OR iter columns), flag this prominently in your report as a Strategy-modifying finding. STRATEGY.md row 1's `~40-70` envelope was historically defensible; if your fresh per-sub-phase audit collapses to a tighter or wider range, the planner needs to know to revise STRATEGY.md.
