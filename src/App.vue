<template>
  <div id="app" class="flex flex-col min-h-screen">
    <SidebarAgent/>
    <header>
      <NavbarAgent/>
    </header>
    <LabList class="flex-grow"/>
    <AgentFooter/>
  </div>
</template>

<script>
import LabList from './components/LabList.vue';
import NavbarAgent from "./components/NavbarAgent.vue";
import SidebarAgent from "./components/SidebarAgent.vue";
import AgentFooter from "./components/AgentFooter.vue";

export default {
  name: 'App',
  components: {
    LabList,
    NavbarAgent,
    SidebarAgent,
    AgentFooter
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
