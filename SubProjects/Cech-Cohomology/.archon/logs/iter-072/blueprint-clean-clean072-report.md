# blueprint-clean report — slug clean072

## Target
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Actions taken

### 5 purity edits in the focused blocks

| # | Location | Issue | Fix |
|---|----------|-------|-----|
| 1 | `lem:coreIso_comm_coface` proof (~line 8851) | `\operatorname{Pi.lift}` Lean name as inline commentary | Removed parenthetical "(the `\operatorname{Pi.lift}` projection of the section coface)" |
| 2 | `lem:coreIso_comm_sum` proof (~lines 8881–8885) | "(Finset sum congruence)" Lean implementation note; "discharging every degree at once" tactic phrasing; entire second sentence citing `comp_sum`/`map_sum` and `AddCommGrp`-hom | Collapsed to one clean sentence: "A termwise comparison of the two alternating sums therefore yields equality of the differentials in every degree." |
| 3 | `lem:coreIso_comm` proof (~lines 8924–8925) | "The prover therefore discharges `h_compat` alongside this lemma, as its p=0 case, rather than as a separate obligation." — prover-role phrasing | Replaced with: "Thus `h_compat` is the p=0 instance of this intertwining identity." |
| 4 | `lem:cechSection_complex_iso` proof (~lines 9090–9095) | "\emph{definitional up to…}" and "by the identity / definitional reduction rather than a diagram chase" — Lean defeq terminology | Changed "definitional up to" → "canonical up to"; "by the identity / definitional reduction rather than a diagram chase" → "by construction" |
| 5 | `lem:cechSection_contractible` proof (~lines 9158–9161) | Parenthetical "(here cited only as the Lean home of the `\operatorname{dep*}` engine declarations — its standard-cover Čech-vanishing conclusion is not a mathematical dependency…)" | Removed parenthetical entirely; engine names and `\uses{}` references kept intact |

### Quick LaTeX sanity scan of the rest of the chapter
- `\begin{}`/`\end{}` environment count: 501/501 — balanced.
- Display-math `\[`/`\]` in target region (lines 8780–9210): 8/8 — balanced.
- `\label{}`, `\lean{}`, `\uses{}` content: untouched throughout.
- `\leanok` / `\mathlibok` / `% NOTE:` markers: untouched throughout.
- No `% NOTE:` or `% SOURCE QUOTE:` blocks were modified.
- No mathematical content, proof structure, or operator-style names altered.

## Constraints respected
- No `\label{}`, `\lean{}`, `\uses{}` content altered.
- No semantic markers (`\leanok`, `\mathlibok`, `% NOTE:`) altered.
- No proof restructuring or mathematical content changes.
- No new blocks added.
- All `\operatorname{…}` names denoting project/Mathlib declarations retained.
