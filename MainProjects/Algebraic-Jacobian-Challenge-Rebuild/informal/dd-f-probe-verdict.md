# DD-F probe verdict — P-fib persistence (RECON/probe)

*Date 2026-07-16. Lane DD-F (the P-fib persistence heart), DAT-D campaign.
Status: IN PROGRESS. Author: Fable probe agent (continuation after two
session-limit deaths; no prior on-disk state).*

BINDING references: `informal/dat-d-worksheet.md` §3.2–3.3 (P-fib, F1–F4),
§5 DD-F probe gate, §6 risk 1; addendum commit 5ee7fd62c (DAT-0b/DAT-5
spellings); DD-0 exports a0509aa95 (SectionBound) + f17afc913 (WindowLedger).

## Question

P-fib (worksheet §3.2): over a field `K ⊇ k'`, given `K_M ⊆ H_M ⊗ K`,
`K' ⊆ H_{M+s} ⊗ K` of codimension exactly `g` with `μ(H_s ⊗ K_M) ⊆ K'` (the
carve `(♦)`), there is a UNIQUE effective divisor `D`, `deg D = g`, with
`K_M = H⁰(𝒪(MF − D))` and `K' = H⁰(𝒪((M+s)F − D))`. The probe must decide the
route F1→F4, above all **F3** (lane rigidity endgame) — the campaign's single
open mathematical step. Gate: GREEN = F3 closed; AMBER = DD-Φ; RED = escalate.

## Inputs read

- DD-0 (ii) WindowLedger (`RiemannRoch/WindowLedger.lean`, f17afc913): constants
  `windowBound b` (:107, spec :112), `windowδ` (:120, `1 ≤ δ` :123,
  `deg F = δ` :131), `windowS_choice s` (:150, spec :154 — `(s−1)δ ≥ b+2g`),
  `windowM_choice M` (:174, spec :177). Window lemmas BY NAME: embedding
  (:240,:249), multiplier (:261), normalization ± shift (:271,:281 for
  `deg D ≤ 2g`), **lane windows** (:295,:311 — `h¹(𝒪(A·F − D − j·P)) = 0` for
  `deg D ≤ 2g`, `j ≤ g+1`), multiplier lane (:332), rank forms
  `h⁰ = A·δ + χ(𝒪_Y)` (:345,:352,:362).
- DD-0 (i) SectionBound (`RiemannRoch/SectionBound.lean`, a0509aa95):
  `h1`-peeling kit (:67,:89,:98,:115,:159), effective witness
  `exists_effective_of_h0_pos` (:175), section bound `h⁰ ≤ max 0 (deg A + 1)`
  (:235, `h⁰(𝒪_X)=1` form :248, linear form :258). F1's `ℓ ≤ 2g` input.
- Worksheet §3.3 route F1–F4 + §3.6(a) pencil counterexample (the probe must
  attack full-`H_s` rigidity, not the pencil weakening).

## Findings

(to fill: distilled conclusions, one bullet per established step)

## Verdict

(to fill: GREEN = F3 closed / AMBER = DD-Φ fallback / RED — per worksheet §5)

## Obstructions

(to fill: precise walls, if any)

## Remainder

(to fill: what stays open for the next session)
