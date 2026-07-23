---
author: sync
chapter: Flat base change for the pushforward of a quasi-coherent sheaf ($i=0$)
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:pushforward_base_change_map
lean_status: lean_ok
order: 108
title: Base-change map for the pushforward
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Source: Stacks Project, Cohomology of Schemes, \S\,Cohomology and base
  change, I.}
  Let \(f : X \to S\) be a morphism of schemes, \(\mathcal{F}\) a quasi-coherent
  \(\mathcal{O}_X\)-module, and \(g : S' \to S\) an arbitrary morphism, giving the
  cartesian square above with projection \(g' : X' \to X\) and
  \(\mathcal{F}' = (g')^*\mathcal{F}\). The \emph{base-change map for the
  pushforward} is the canonical morphism of \(\mathcal{O}_{S'}\)-modules
  \[
    g^*\bigl(f_*\mathcal{F}\bigr) \longrightarrow f'_*\bigl((g')^*\mathcal{F}\bigr)
    = f'_*\mathcal{F}' .
  \]
  It is adjoint to the morphism
  \(f_*\mathcal{F} \to g_*\, f'_*\mathcal{F}' = f_*\,(g')_*\mathcal{F}'\) obtained
  by applying \(f_*\) to the unit
  \(\mathcal{F} \to (g')_*(g')^*\mathcal{F}\) of the
  \(((g')^*, (g')_*)\)-adjunction, using the commutativity
  \(g \circ f' = f \circ g'\) of the square.