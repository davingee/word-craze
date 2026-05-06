import { Controller } from "@hotwired/stimulus"
import * as d3 from "d3"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.loadAndRender()
  }

  disconnect() {
    if (this.simulation) this.simulation.stop()
  }

  async loadAndRender() {
    try {
      const res = await fetch(this.urlValue, { headers: { Accept: "application/json" } })
      const data = await res.json()
      this.render(data)
    } catch (err) {
      console.error("Graph load failed:", err)
    }
  }

  render({ word, associations }) {
    const el = this.element
    d3.select(el).selectAll("svg").remove()

    const width = el.clientWidth || 800
    const height = el.clientHeight || 500

    const nodes = [
      { id: word.id, label: word.name, isCenter: true, href: null, size: 5 },
      ...associations.map(a => ({
        id: a.id,
        label: a.name,
        isCenter: false,
        href: `/?association_id=${a.id}`,
        size: Math.max(1, a.count)
      }))
    ]

    const links = associations.map(a => ({
      source: word.id,
      target: a.id,
      value: Math.max(1, a.count)
    }))

    const svg = d3.select(el)
      .append("svg")
      .attr("width", width)
      .attr("height", height)

    const linkSel = svg.append("g")
      .selectAll("line")
      .data(links)
      .join("line")
      .attr("stroke", "#cbd5e1")
      .attr("stroke-width", d => Math.max(1, Math.sqrt(d.value)))

    const nodeSel = svg.append("g")
      .selectAll("g")
      .data(nodes)
      .join("g")
      .attr("cursor", d => d.isCenter ? "default" : "pointer")
      .call(
        d3.drag()
          .on("start", (event, d) => {
            if (!event.active) this.simulation.alphaTarget(0.3).restart()
            d.fx = d.x
            d.fy = d.y
          })
          .on("drag", (event, d) => {
            d.fx = event.x
            d.fy = event.y
          })
          .on("end", (event, d) => {
            if (!event.active) this.simulation.alphaTarget(0)
            d.fx = null
            d.fy = null
          })
      )
      .on("click", (_event, d) => {
        if (d.href) window.location.href = d.href
      })

    nodeSel.append("text")
      .text(d => d.label)
      .attr("text-anchor", "middle")
      .attr("dy", "0.35em")
      .attr("fill", d => d.isCenter ? "#1e40af" : "#334155")
      .attr("font-size", d => `${Math.max(12, Math.sqrt(d.size * 250))}px`)
      .attr("font-weight", d => d.isCenter ? "bold" : "normal")
      .attr("font-family", "system-ui, -apple-system, sans-serif")
      .attr("pointer-events", "none")

    this.simulation = d3.forceSimulation(nodes)
      .force("link", d3.forceLink(links).id(d => d.id).distance(160))
      .force("charge", d3.forceManyBody().strength(-400))
      .force("center", d3.forceCenter(width / 2, height / 2))
      .force("collision", d3.forceCollide().radius(d => Math.max(20, Math.sqrt(d.size * 250) / 2 + 10)))

    this.simulation.on("tick", () => {
      linkSel
        .attr("x1", d => d.source.x)
        .attr("y1", d => d.source.y)
        .attr("x2", d => d.target.x)
        .attr("y2", d => d.target.y)

      nodeSel.attr("transform", d => `translate(${d.x},${d.y})`)
    })
  }
}
