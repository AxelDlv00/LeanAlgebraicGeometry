# Rendering cleanup — Albanese_AlbaneseUP.tex (iter-279)

Chapter: `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
Scope: NON-SEMANTIC rendering fixes only. No statement text, `\lean{}`, `\label{}`,
`\uses{}`, `\leanok` touched (verified by count: 14 `\lean`, 27 `\label`, 13 `\uses`,
6 `\leanok` — all unchanged; no blocks added/removed/reordered).

## math-delim fixes (inverted `$MATH\( prose \)MATH$` → `\(MATH\) prose \(MATH\)`)

All in rendered prose (no `%`-comment edited). Pure delimiter swaps; math content preserved.

| Line | before (delim shape) | after |
|------|----------------------|-------|
| 78–79 | `$C \times_{\bar k} T\(, … \)T$` | `\(C \times_{\bar k} T\), … \(T\)` |
| 83–84 | `$\psi \colon J \to A\( … \)\varphi \colon C \to A$` | `\(\psi…\)` / `\(\varphi…\)` |
| 368–369 | `$U^{(g)} \subseteq \mathrm{Sym}^g C\( … \)S_g$-invariants` | `\(U^{(g)}…\) … \(S_g\)-invariants` |
| 434–435 | `$\mathrm{add}_A \circ \tau = \mathrm{add}_A\( … \)\tau \in S_g\( … \)A^g$` | three `\(…\)` |
| 439–440 | `$\varphi^{\times g} \colon C^g \to A^g$` (balanced) | `\(…\)` |
| 506–507 | `$\mathrm{Sym}^g C\( … \)\dim |D| = 0\( … \)g$` | three `\(…\)` |
| 547–551 | `$h^0(D)-h^1(D)=1\(,…\)…\)h^1$ … `$h^0(D)=1\(…\)|D|\(…\)D$` | six `\(…\)` |
| 560–562 | `$[\mathcal O_{…}]\(,…\)\mathcal D_g…\)g\( on \)C$` | four `\(…\)` |
| 615–618 | `$f^{(g)}|_U…\)\psi_0…$` … `$\mathrm{Sym}^g\varphi|_U…\)J \dashrightarrow A$` | `\(…\)` ×4 |
| 688–689 | `$\mathrm{Sym}^g \varphi\( … \)\psi \colon J \to A$` | `\(…\)` ×2 |
| 785 | `$H^1(C,\mathcal O_C)\(, … \)g(C)$` | `\(H^1(C,\mathcal O_C)\), … \(g(C)\)` |
| 795–796 | `$\bar k\( … \)k$` | `\(\bar k\) … \(k\)` |

### Standalone balanced `$…$` → `\(…\)` (delimiter-style uniformity)
These were NOT interleaved (rendered fine), converted for one-style consistency per directive
("use `\( … \)`"); pure delimiter swap:

| Line | formula |
|------|---------|
| 273–274 | `\mathcal L^{P_0} := \mathcal O_{C\times C}\bigl(\Delta-…\bigr)` |
| 608–609 | `\mathrm{Sym}^g \varphi \circ (f^{(g)})^{-1} \colon J \dashrightarrow A` |
| 726–727 | `[\mathcal O_C(Q+(g-1)P_0-gP_0)] = [\mathcal O_C(Q-P_0)] = \iota_{P_0}(Q)` |
| 751–752 | `\iota_{P_0}(C) \subseteq J` |

## bare-label fix (line ~788) — RESOLVED BY REWORDING (target excised)

The directive asked to wrap `lem:agps` as `\cref{lem:agps}`. **This was NOT possible**:
neither `lem:agps` nor `prp:pic0` has a live `\label{}` anywhere in the blueprint — they
occur ONLY inside `%`-commented Kleiman source quotes
(`Picard_IdentityComponent.tex:72`, `Picard_Pic0AbelianVariety.tex:460`). They are
**Kleiman's external-paper internal labels** (cf. `Jacobian.tex:183`: "Kleiman, The Picard
Scheme, Lem.~(lem:agps), Prp.~(prp:pic0)"). Emitting `\cref{lem:agps}` would have created a
NEW broken reference — forbidden by the hard constraint ("NEVER emit a `\cref{}` to a label
that does not exist").

Per defect-class-3's external-label rule ("for an EXTERNAL paper's internal label, the
source's human-readable form"), I reworded:

- before: `(Kleiman Lem.~lem:agps and Prp.~prp:pic0; cf.\ \cref{thm:Jacobian_geomIrred}'s discussion)`
- after:  `(Kleiman, \emph{The Picard scheme}, the identity-component lemma and its \(\Pic^0_{C/k}\) specialisation; cf.\ \cref{thm:Jacobian_geomIrred}'s discussion)`

(`\Pic` macro already used throughout this chapter; `\cref{thm:Jacobian_geomIrred}` retained,
that label is live.)

## Verification (post-edit greps)
- `grep REF` → 0 hits.
- `$` in non-comment lines → 0 hits.
- `lem:agps` / `prp:pic0` in non-comment prose → 0 hits.
- No `\cref{}` introduced to a non-existent label (the one `\cref` retained,
  `thm:Jacobian_geomIrred`, is live).
- `\lean`/`\label`/`\uses`/`\leanok` counts unchanged; no statement/proof math altered.

## Unresolved
None. All flagged defects fixed; the single bare-label was resolved by rewording because its
target is an external (Kleiman) label with no live blueprint `\label`.
