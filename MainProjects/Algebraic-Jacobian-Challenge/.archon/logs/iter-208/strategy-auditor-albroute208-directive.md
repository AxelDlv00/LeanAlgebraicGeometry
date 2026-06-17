# Strategy-auditor directive — iter-208

## The strategic question (Albanese UP route choice)

The project's goal is an Albanese/Jacobian universal property `isAlbaneseFor`
for a smooth proper geometrically irreducible curve `C/k`, with `J := Pic⁰_{C/k}`.
There are two candidate routes to the universal property, and the choice
determines whether a large, long-stuck substrate cone can be **excised**:

- **Route (1) — Milne Thm 3.2 cone.** Extend the Abel–Jacobi rational map
  `C ⇢ J` across all of `C` using: codim-1 extension + a codim-≥2 extension
  step (project Lane COE, blocked 27 iters on the Stacks tag **02JK** conormal
  isomorphism) + Milne's Thm 3.2 / Prop 3.10 rational-map-extension machinery.
  This cone includes the files `Albanese/CodimOneExtension.lean`,
  `Albanese/Thm32RationalMapExtension.lean`, `Albanese/AuslanderBuchsbaum.lean`.

- **Route (2) — Kleiman `rmk:Alb`.** The universal property falls out of
  `Pic_{C/k}` *representability* (A.2.c) directly, RR-free — but (the project
  believes) it outputs the UP on the DUAL `J^∨`, so landing the goal's
  `isAlbaneseFor` on `J` itself requires an **autoduality bridge** `J^∨ ≅ J`
  (which may itself need Riemann–Roch).

If Route (2) genuinely delivers a usable universal property (autoduality bridge
included, at acceptable cost), it **obsoletes the entire Route (1) cone**,
including the 27-iter-stuck COE / 02JK node — letting me delete those strategy
rows and held lanes.

## What I need you to audit against the actual sources

Read the real source files (not just the `.md` pointers):

- `references/kleiman-picard.pdf` (or `references/kleiman-picard-src/*.tex`) —
  Kleiman "The Picard scheme", FGA Explained. Find the **`rmk:Alb`** / Albanese
  remark and the §6.1/autoduality material. The project summary points to
  §III.6 Albanese-UP and the Pic⁰ Jacobian sections (pp. 36–51).
- `references/abelian-varieties.pdf` — Milne "Abelian Varieties". **Thm 3.2 +
  Prop 3.10** (§I.3, pp. 15–20) and the **Albanese universal property Prop
  6.1/6.4** (§III.6, p. 104).

Audit questions:

1. **Does Kleiman actually derive the Albanese/universal property from
   representability of `Pic`** (Route 2), and if so, on `J` or on `J^∨`? Quote
   the precise statement. Is the autoduality `J^∨ ≅ J` for a curve's Jacobian
   stated there, and what does it cost (does it invoke Riemann–Roch or a
   principal polarization)?
2. **Is the Milne Thm-3.2 cone (Route 1) actually necessary** for the goal as
   stated, or is it a route the project invented that the references obtain more
   cheaply via representability?
3. **Is the codim-≥2 / Stacks-02JK extension step a genuine prerequisite of
   Route 1**, or an over-decomposition — does Milne/Kleiman extend the rational
   map without a separate codim-≥2 conormal argument?
4. Bottom line: should the project **commit to Route (2) and excise the Route
   (1) cone**, keep both alive, or is Route (2)'s autoduality bridge a hidden
   show-stopper that makes Route (1) the safer path?

Cite section/page/quote for every finding. Write your report to
`task_results/strategy-auditor-albroute208.md`.
