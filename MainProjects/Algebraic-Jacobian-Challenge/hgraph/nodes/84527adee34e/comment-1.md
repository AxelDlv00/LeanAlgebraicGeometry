---
author: horizon
created: '2026-07-29T18:54:42'
date: '2026-07-29T18:54:42'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '0'
  rounds: '8'
  run: 0081
  session: 0002-horizon-review-ajc
  task: review-ajc
  task_title: 'REVIEWER (AJC): audit the representability route, board and Lean quality'
title: 'Route: Grassmannian + finite Galois, not Quot; ten modules absent'
updated: '2026-07-29T18:54:42'
---
ROUTE CORRECTION — Quot and Serre are NOT this obligation's inputs
(review-ajc, 2026-07-29).

The Lean carrier is `Scheme.fgaPicardRepresentability`
(`Picard/FGAPicRepresentability.lean:347`), a bare `sorry`, and it is the single
statement the whole AJC Jacobian tower rests on.

Until this round its docstring said discharging it needs `Div` representability
"which needs the Quot scheme" (Kleiman §3 `th:repDiv`) together with the
Altman-Kleiman quotient lemma, and that neither input is available. Both named
inputs belong to the GROTHENDIECK/KLEIMAN QUOTIENT route, which this project
does not take and marked `rejected` on the board (`AJC.picrep.quot`,
`AJC.picrep.serre`). A reader trusting the docstring concluded that the seam's
own inputs had been abandoned — i.e. that rejecting Quot while keeping the sorry
was incoherent. It is not incoherent; the docstring was stale, and it is
corrected in place this round.

THE COMMITTED ROUTE is Milne-Kollar (`informal/pic-representability-campaign.md`,
alternative D3):
* `Div^d` representability goes through the GRASSMANNIAN, not Quot — degree
  slices (D1', landed in `Picard/DivDegree.lean`), the embedding into
  `Scheme.Grassmannian` of the section module (D2'), locally closed carving
  (D3'), then `Div^d` as a scheme plus the locally-closed-immersion certificate
  into `Gr` that serves for quasi-projectivity (D4'), resting on
  `Grassmannian.representable`, which is proved.
* the quotient is the FINITE GALOIS quotient of a semilinear action whose finite
  orbits lie in affine opens (G2), landed sorry-free in
  `Picard/FiniteGaloisQuotient.lean` with Speiser descent under
  `Picard/GaloisDescent/`. NOT `smoothProperQuotient`.

WHAT REMAINS, by module existence rather than assertion. Absent from disk, i.e.
not started: B1 `PicSharpZariskiSheaf`, B4 `PicSharpDegree`, B6
`PicSharpSeparatedDevice`, D2' `DivGrassmannianEmbedding`, D3' `DivLocallyClosed`,
D4' `DivRepresentability`, J1-J5 `MilneGlue`, G3 `PicSharpGaloisDescent`, G4
`PicTotalAssembly`, P5 `UniformVanishing` (= the open `AJC.rr.extuniform` leaf).
Ten modules, three campaign-sized XL, on the path
P5 -> D2'/D3' -> D4' -> J1-J5 -> G3 -> G4 -> this sorry. J5 additionally needs a
universe bridge: `picSharp` is `Type (u+1)`-valued while mathlib's 01JJ
representability engine wants `Type u`.

CONSUMER SIDE. The instance `instHasPicSchemeEt` (line 366) is
`(fgaPicardRepresentability C).1`, so the `HasPicSchemeEt` gate synthesizes
freely and carries this sorry into every consumer. The legacy `HasPicScheme`
(line 263) has zero instances and is uninhabited — its only producer needs
`[HasRationalPoint C]`, which has no unconditional producer either. New work
goes against `HasPicSchemeEt` / `picEt`.
